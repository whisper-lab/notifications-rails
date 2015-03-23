class Message < ActiveRecord::Base
  before_create :set_date_to_now
  before_create :set_body_to_empty_string

  belongs_to :channel

  validates :channel_id, presence: true
  validates :body, presence: true

  private

    def set_date_to_now
      self.date ||= DateTime.now
    end

    def set_body_to_empty_string
      self.body ||= ""
    end
end
