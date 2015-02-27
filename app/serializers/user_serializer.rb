class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :lat, :lng, :sex
  has_one :device
end
