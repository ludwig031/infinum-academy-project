RSpec.describe User, type: :model do
  subject(:user) { FactoryBot.build(:user) }

  it 'is valid with valid attributes' do
    is_expected.to be_valid
  end

  it 'is invalid without an first name' do
    is_expected.to validate_presence_of(:first_name)
  end

  it 'is invalid without an last name' do
    is_expected.to validate_presence_of(:last_name)
  end

  it 'is invalid without an email' do
    is_expected.to validate_presence_of(:email)
  end

  it 'is invalid without unique email' do
    is_expected.to validate_uniqueness_of(:email).case_insensitive
  end
end
