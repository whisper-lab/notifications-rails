module MessagesHelper

  def get_formatted_title(message)
    if (message.title.nil? || message.title.empty?)
      title = raw(message.channel.name)
    else
      title = raw(message.title)
    end
  end
end
