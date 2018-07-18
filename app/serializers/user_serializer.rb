class UserSerializer < ActiveModel::Serializer
  attribute :id
  attribute :first_name
  attribute :last_name
  attribute :email
  has_many :bookings
  has_many :flights
  attribute :created_at
  attribute :updated_at
end
