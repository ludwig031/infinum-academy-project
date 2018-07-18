FactoryBot.define do
  factory :booking do
    no_of_seats 1
    seat_price 2
    flight { FactoryBot.create(:flight) }
    user { FactoryBot.create(:user) }
  end
end
