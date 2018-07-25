RSpec.describe Company, type: :model do
  subject(:company) { FactoryBot.build(:company) }

  it { is_expected.to validate_presence_of(:name) }

  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
end
