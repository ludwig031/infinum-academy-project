FactoryBot.define do
  factory :flight do
    sequence(:name) { |n| "flight-##{n}" }
    flys_at { Time.zone.now + 1.hour }
    lands_at { Time.zone.now + 2.hours }
    base_price 100
    no_of_seats 100
    company
  end
end
