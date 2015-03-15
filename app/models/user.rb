require 'core_ext/string'

class User < ActiveRecord::Base
  validates :name, presence: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  extend FriendlyId
  friendly_id :email, use: :slugged

  has_one :device, dependent: :destroy
  has_many :channels
  has_many :subscriptions
  has_many :subscribed_channels, through: :subscriptions, source: :channel

  validates :sex, inclusion: %w(male female)

  accepts_nested_attributes_for :device

  before_create do |doc|
    doc.api_key = doc.generate_api_key
  end

  def normalize_friendly_id(string)
    string.to_s.friendlyerize
  end

  def generate_api_key
    loop do
      token = SecureRandom.urlsafe_base64(25).tr('lIO0', 'sxyz')
      break token unless User.exists?(api_key: token)
    end
  end
end
