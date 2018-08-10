require 'rails_helper'

RSpec.describe UserPolicy do
  subject { described_class.new(user, current_user) }

  let(:user) { FactoryBot.create(:user) }

  before { user }

  context 'when user is authotized' do
    let(:current_user) { user }

    before { current_user }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }
  end

  context 'when user is not authotized in' do
    let(:current_user) { FactoryBot.create(:user) }

    before { current_user }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to forbid_action(:show) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:destroy) }
  end
end
