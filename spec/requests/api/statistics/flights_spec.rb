RSpec.describe 'Statistics Flights API', type: :request do
  include TestHelpers::JsonResponse

  let(:user) { FactoryBot.create(:user) }

  describe 'GET /api/statistics/flights' do
    let(:flights) { FactoryBot.create_list(:flight, 3) }

    before { flights }

    it 'returns status code 200' do
      get '/api/statistics/flights', headers: { Authorization: user.token }

      expect(response).to have_http_status(:ok)
    end

    it 'successfully returns list of flights' do
      get '/api/statistics/flights', headers: { Authorization: user.token }

      expect(json_body).to include('flights')
    end

    it 'successfully returns 3 flights' do
      get '/api/statistics/flights', headers: { Authorization: user.token }

      expect(json_body['flights'].length).to eq(3)
    end

    it 'returns flight_id' do
      get '/api/statistics/flights', headers: { Authorization: user.token }

      expect(json_body['flights'][0]).to include('flight_id')
    end

    it 'returns revenue' do
      get '/api/statistics/flights', headers: { Authorization: user.token }

      expect(json_body['flights'][0]).to include('revenue')
    end

    it 'returns no_of_booked_seats' do
      get '/api/statistics/flights', headers: { Authorization: user.token }

      expect(json_body['flights'][0]).to include('no_of_booked_seats')
    end

    it 'returns occupancy' do
      get '/api/statistics/flights', headers: { Authorization: user.token }

      expect(json_body['flights'][0]).to include('occupancy')
    end
  end
end
