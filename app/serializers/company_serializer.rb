class CompanySerializer < ActiveModel::Serializer
  attribute :id
  attribute :name
  has_many :flights
  attribute :created_at
  attribute :updated_at
end
