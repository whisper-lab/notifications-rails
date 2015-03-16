class Subscription < ActiveRecord::Base
  before_create :set_subscription_date_to_now

  belongs_to :user
  belongs_to :channel

  private

    def set_subscription_date_to_now
      self.subscription_date ||= DateTime.now
    end
end
