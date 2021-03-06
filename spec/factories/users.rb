FactoryBot.define do
  factory :user do
    first_name 'Ime'
    last_name 'Prezime'
    sequence(:email) { |n| "user-#{n}@email.com" }
    password 'defaultPassword'
    sequence(:token) { |n| "token-#{n}" }
  end
end
