RSpec.describe Company, type: :model do
  subject(:company) { FactoryBot.build(:company) }

  it 'is invalid without an name' do
    is_expected.to validate_presence_of(:name)
  end

  it 'is invalid without unique name' do
    is_expected.to validate_uniqueness_of(:name).case_insensitive
  end
end
