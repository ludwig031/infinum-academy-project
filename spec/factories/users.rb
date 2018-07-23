FactoryBot.define do
  factory :user do
    first_name 'Ime'
    last_name 'Prezime'
    sequence(:email) { |n| "user-#{n}@email.com" }
  end
end
