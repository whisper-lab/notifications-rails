class Channel < ActiveRecord::Base
  belongs_to :user

  has_many :subscriptions
  has_many :subscribed_users, -> { uniq }, through: :subscriptions, source: :user

  has_many :messages, dependent: :destroy

  validates :name, presence: true
end
