RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create(:user) }

  before do
    FactoryBot.reload
  end

  it 'is valid with valid attributes' do
    expect(user).to be_valid
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
    User.new(first_name: 'ime', last_name: 'prezime', email: 'mail@mail.com').save!(validate: false)
    is_expected.to validate_uniqueness_of(:email).case_insensitive
  end
end
