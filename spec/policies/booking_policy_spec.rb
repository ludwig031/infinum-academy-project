require 'rails_helper'

RSpec.describe BookingPolicy do
  subject { described_class.new(user, booking) }

  let(:user) { FactoryBot.create(:user) }

  before { user }

  context 'when user authorized' do
    let(:booking) { FactoryBot.create(:booking, user: user) }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }
  end

  context 'when user is not authorized' do
    let(:booking) { FactoryBot.create(:booking) }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to forbid_action(:show) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:destroy) }
  end
end
