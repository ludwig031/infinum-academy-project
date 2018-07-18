FactoryBot.define do
  factory :booking do
    no_of_seats 1
    seat_price 2
    flight
    user
  end
end
