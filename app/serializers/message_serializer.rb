class MessageSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :sent, :date
end
