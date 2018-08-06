RSpec.describe 'Statistics Company API', type: :request do
  include TestHelpers::JsonResponse

  let!(:user) { FactoryBot.create(:user) }

  describe 'GET /api/statistics/companies' do
    let(:flights) { FactoryBot.create_list(:flight, 3) }

    before { flights }

    it 'returns status code 200' do
      get '/api/statistics/companies', headers: { Authorization: user.token }

      expect(response).to have_http_status(:ok)
    end

    it 'successfully returns list of companies' do
      get '/api/statistics/companies', headers: { Authorization: user.token }

      expect(json_body).to include('companies')
    end

    it 'successfully returns 3 companies' do
      get '/api/statistics/companies', headers: { Authorization: user.token }

      expect(json_body['companies'].length).to eq(3)
    end

    it 'returns flight_id' do
      get '/api/statistics/companies', headers: { Authorization: user.token }

      expect(json_body['companies'][0]).to include('company_id')
    end

    it 'returns total_revenue' do
      get '/api/statistics/companies', headers: { Authorization: user.token }

      expect(json_body['companies'][0]).to include('total_revenue')
    end

    it 'returns total_no_of_booked_seats' do
      get '/api/statistics/companies', headers: { Authorization: user.token }

      expect(json_body['companies'][0]).to include('total_no_of_booked_seats')
    end

    it 'returns average_price_of_seats' do
      get '/api/statistics/companies', headers: { Authorization: user.token }

      expect(json_body['companies'][0]).to include('average_price_of_seats')
    end
  end
end
