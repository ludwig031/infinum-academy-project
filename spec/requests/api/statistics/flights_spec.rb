RSpec.describe 'Statistics Flights API', type: :request do
  include TestHelpers::JsonResponse
  include TestHelpers::OccupancyCalculation

  let(:user) { FactoryBot.create(:user) }

  describe 'GET /api/statistics/flights' do
    let(:flights) { FactoryBot.create_list(:flight, 3) }
    let(:bookings) do
      FactoryBot.create_list(:booking, 3,
                             flight_id: flights.first.id)
    end

    before do
      flights
      bookings
    end

    it 'returns status code 200' do
      get '/api/statistics/flights', headers: { Authorization: user.token }

      expect(response).to have_http_status(:ok)
    end

    it 'successfully returns list of flights' do
      get '/api/statistics/flights', headers: { Authorization: user.token }

      expect(json_body).to include('flights')
    end

    it 'returns flight_id' do
      get '/api/statistics/flights', headers: { Authorization: user.token }

      expect(json_body['flights'][0])
        .to include('flight_id' => flights.first.id)
    end

    it 'returns revenue' do
      get '/api/statistics/flights', headers: { Authorization: user.token }

      expect(json_body['flights'][0])
        .to include('revenue' => flights.first.bookings.sum(:seat_price))
    end

    it 'returns no_of_booked_seats' do
      get '/api/statistics/flights', headers: { Authorization: user.token }

      expect(json_body['flights'][0])
        .to include('no_of_booked_seats' =>
                      flights.first.bookings.sum(:no_of_seats))
    end

    it 'returns occupancy' do
      get '/api/statistics/flights', headers: { Authorization: user.token }

      expect(json_body['flights'][0]).to include('occupancy' => occupancy)
    end
  end
end
