class FlightCalculator
  attr_reader :flight

  def initialize(flight)
    @flight = flight
  end

  def price
    difference = 15 - (flight.flys_at.to_date - Date.current)
    difference = difference.negative? ? 0 : difference
    difference = difference > 15 ? 15 : difference
    (flight.base_price * (1 + difference / 15)).round
  end
end
