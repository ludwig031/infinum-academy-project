class BookingPolicy < ApplicationPolicy
  attr_reader :user, :booking

  def initialize(user, booking)
    @user = user
    @booking = booking
  end

  def show?
    return if current_user == booking.user
    render json: { errors: { resource: ['is forbidden'] } },
           status: :forbidden
  end

  def update?
    return if current_user == booking.user
    render json: { errors: { resource: ['is forbidden'] } },
           status: :forbidden
  end

  def destroy?
    return if current_user == booking.user
    render json: { errors: { resource: ['is forbidden'] } },
           status: :forbidden
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
