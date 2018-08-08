class UserPolicy < ApplicationPolicy
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def show?
    return if current_user == user
    render json: { errors: { resource: ['is forbidden'] } },
           status: :forbidden
  end

  def update?
    return if current_user == user
    render json: { errors: { resource: ['is forbidden'] } },
           status: :forbidden
  end

  def destroy?
    return if current_user == user
    render json: { errors: { resource: ['is forbidden'] } },
           status: :forbidden
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
