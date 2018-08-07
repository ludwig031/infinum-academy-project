FactoryBot.define do
  factory :flight do
    sequence(:name) { |n| "flight-##{n}" }
    flys_at { 5.days.from_now }
    lands_at { 7.days.from_now }
    base_price 100
    no_of_seats 100
    company
  end
end
