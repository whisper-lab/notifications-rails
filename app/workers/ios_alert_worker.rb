class IosAlertWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  # # Sidetiq should schedule this job every half hour between 08:30 - 16:30 every Monday-Friday.
  # # Note: The job will be queued at this time, not executed.
  # recurrence do
  #   weekly(1).
  #     day(:monday, :tuesday, :wednesday, :thursday, :friday).
  #     hour_of_day((8..16).to_a).
  #     minute_of_hour(0, 30)
  # end

  recurrence do
    minutely(1)
  end

  # Set the Sidekiq Queue to 'ios_alert_worker_queue', enable backtrace logging, and retry if the job fails
  sidekiq_options :queue => :ios_alert_worker_queue, backtrace: true, retry: true

  def perform
    fname = "tempfile.pem"
    temp_file = Tempfile.new(fname)
    begin
      # open the file, and copy the contents from the file on AWS-S3
      File.open(temp_file, 'wb') do |fo|
        # fo.print open(Aws::S3::S3Object.url_for('certificate.pem', S3_BUCKET_PNS)).read
        fo.print S3_BUCKET_PNS.object('certificate.pem').get.body.read
      end
      file = File.new(temp_file)

      # Keep the connection to gateway.push.apple.com open throughout the duration of this job
      pusher = Grocer.pusher(
        certificate: file.path,                # required
        passphrase:  "",                       # optional
        gateway:     "gateway.sandbox.push.apple.com", # optional
        port:        2195,                     # optional
        retries:     3                         # optional
      )

      User.joins(:device, {:subscriptions => {:channel => :messages}})
          .where('devices.platform' => 'ios', 'messages.sent' => nil)
          .pluck('devices.token','channels.id','channels.name','messages.title','messages.body','messages.date','messages.id')
          .each do |token, channel_id, channel_name, title, body, date, message_id|
        if title.nil? or title.empty?
          title = channel_name
        end
        notification = Grocer::Notification.new(
          device_token:      token,
          alert:             {title: title || channel_name, body: body},
          badge:             42,
          sound:             "siren.aiff",         # optional
          expiry:            Time.now + 60*60,     # optional; 0 is default, meaning the message is not stored
          identifier:        1234,                 # optional
          content_available: true,                  # optional; any truthy value will set 'content-available' to 1
          custom: {
            channel: {id: channel_id, name: channel_name},
            message: {id: message_id, date: date}
          }
        )
        pusher.push(notification)
        message = Message.find(message_id)
        message.update(sent: true) if message
      end

      feedback = Grocer.feedback(
          certificate: file.path,                 # required
          passphrase:  "",                        # optional
          gateway:     "feedback.sandbox.push.apple.com", # optional; See note below.
          port:        2196,                      # optional
          retries:     3                          # optional
      )

      feedback.each do |attempt|
        puts "Device #{attempt.device_token} failed at #{attempt.timestamp}"
      end
    ensure
      temp_file.close
      # delete the temporary file
      File.delete(temp_file)
    end
  end
end