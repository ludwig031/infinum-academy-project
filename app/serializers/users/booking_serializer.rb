module Users
  class BookingSerializer < ActiveModel::Serializer
    attribute :id
    attribute :no_of_seats
    attribute :seat_price
    attribute :flight_name
    attribute :flys_at
    attribute :company_name

    def flight_name
      object.flight.name
    end

    def flys_at
      object.flight.flys_at
    end

    def company_name
      object.flight.company.name
    end
  end
end
