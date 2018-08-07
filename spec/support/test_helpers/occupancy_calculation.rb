module TestHelpers
  module OccupancyCalculation
    def occupancy
      no_of_bs = flights.first.bookings.sum(:no_of_seats)
      no_of_fs = flights.first.no_of_seats
      ((no_of_bs.to_f / no_of_fs) * 100).to_s << '%'
    end
  end
end
