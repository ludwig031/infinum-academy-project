FactoryBot.define do
  factory :flight, class: 'Flight' do
    name 'Put u Irsku'
    flys_at { Time.zone.now }
    lands_at { Time.zone.now + 1.hours }
    base_price 100
    no_of_seats 100
    company_id 1
  end
end
