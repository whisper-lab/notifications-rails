class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  extend FriendlyId
  friendly_id :email, use: :slugged

  has_one :device, dependent: :destroy

  validates :email, :sex, presence: true

  accepts_nested_attributes_for :device

  def normalize_friendly_id(string)
    string.to_s.friendlyerize
  end
end
