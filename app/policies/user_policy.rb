class UserPolicy < ApplicationPolicy
  attr_reader :user, :current_user

  def initialize(user, current_user)
    @user = user
    @current_user = current_user
  end

  def show?
    current_user == user
  end

  def update?
    current_user == user
  end

  def destroy?
    current_user == user
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
