class Channel < ActiveRecord::Base
  belongs_to :user

  has_many :subscriptions
  has_many :subscribed_users, -> { uniq }, through: :subscriptions, source: :user

  validates :name, presence: true
end
