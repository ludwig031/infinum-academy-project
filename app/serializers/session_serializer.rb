class SessionSerializer < ActiveModel::Serializer
  attribute :token
  attribute :user
  def user
    UserSerializer.new(self).attributes
  end
end
