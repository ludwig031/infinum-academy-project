class SessionSerializer < ActiveModel::Serializer
  class CustomUserSerializer < UserSerializer
    attribute :id
    attribute :first_name
    attribute :last_name
    attribute :email
  end

  attribute :token
  has_one :user, serializer: CustomUserSerializer
end
