FactoryBot.define do
  factory :flight do
    name 'Put u Irsku'
    flys_at { Time.zone.now + 1.hour }
    lands_at { Time.zone.now + 2.hours }
    base_price 100
    no_of_seats 100
    company
  end

  factory :flight_invalid, class: Flight do
    name 'Put u Irsku'
    flys_at { Time.zone.now + 5.hours }
    lands_at { Time.zone.now + 2.hours }
    base_price 100
    no_of_seats 100
    company
  end
end
