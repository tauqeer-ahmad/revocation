class MessageSerializer < ActiveModel::Serializer
  attributes :id, :body, :status
  has_one :sender
  has_one :recipient
end
