class FlightPolicy < ApplicationPolicy
  attr_reader :user, :flight

  def initialize(user, flight)
    @user = user
    @flight = flight
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
