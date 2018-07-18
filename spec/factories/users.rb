FactoryBot.define do
  factory :user, class: 'User' do
    id 1
    first_name 'Ime'
    last_name 'Prezime'
    email 'some@proper.mail'
  end
end
