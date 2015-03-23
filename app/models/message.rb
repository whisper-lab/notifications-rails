class Message < ActiveRecord::Base
  before_create :set_date_to_now

  belongs_to :channel

  validates :channel_id, presence: true

  private

    def set_date_to_now
      self.date ||= DateTime.now
    end
end
