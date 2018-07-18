FactoryBot.define do
  factory :user, class: 'User' do
    first_name 'Ime'
    last_name 'Prezime'
    email 'some@proper.mail'
  end
end
