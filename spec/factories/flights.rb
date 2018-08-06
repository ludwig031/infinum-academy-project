FactoryBot.define do
  factory :flight do
    sequence(:name) { |n| "flight-##{n}" }
    flys_at { Time.zone.now + 5.days }
    lands_at { Time.zone.now + 7.days }
    base_price 100
    no_of_seats 100
    company
  end
end
