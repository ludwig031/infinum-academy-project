RSpec.describe User, type: :model do
  subject(:user) { FactoryBot.build(:user) }

  it { is_expected.to validate_presence_of(:first_name) }

  it { is_expected.to validate_presence_of(:last_name) }

  it { is_expected.to validate_presence_of(:email) }

  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
end
