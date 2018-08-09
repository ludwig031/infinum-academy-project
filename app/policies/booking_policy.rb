class BookingPolicy < ApplicationPolicy
  attr_reader :user, :booking

  def initialize(user, booking)
    @user = user
    @booking = booking
  end

  def show?
    user == booking.user
  end

  def update?
    user == booking.user || booking.flight.flys_at < Date.current
  end

  def destroy?
    user == booking.user
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
