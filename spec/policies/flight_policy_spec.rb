require 'rails_helper'

RSpec.describe FlightPolicy do
  subject { described_class.new(user, record) }

  let(:user) { FactoryBot.create(:user) }
  let(:record) { FactoryBot.create(:company) }

  before do
    user
    record
  end

  context 'when user is not logged in' do
    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }
  end
end
