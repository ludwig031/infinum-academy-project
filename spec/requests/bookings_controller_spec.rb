RSpec.describe 'Bookings API', type: :request do
  describe 'GET #index' do
    let(:bookings) { FactoryBot.create_list(:booking, 3) }

    before { bookings }

    it 'returns http success' do
      get '/api/bookings'
      expect(response).to have_http_status(:success)
    end

    it 'returns list of bookings' do
      get '/api/bookings'
      json_body = JSON.parse(response.body)
      expect(json_body['bookings'].length).to eq 3
    end
  end

  describe 'GET #show' do
    let(:booking) { FactoryBot.create(:booking) }

    it 'returns http success' do
      get "/api/bookings/#{booking.id}", params: { id: booking.id }
      expect(response).to have_http_status(:success)
    end

    it 'returns a single booking' do
      get "/api/bookings/#{booking.id}", params: { id: booking.id }
      json_body = JSON.parse(response.body)
      expect(json_body).to include('booking')
    end
  end

  describe 'POST #create' do
    context 'when params are valid' do
      let(:flight) { FactoryBot.create(:flight) }
      let(:user) { FactoryBot.create(:user) }

      it 'returns 201' do
        post '/api/bookings', params: { booking: { no_of_seats: 1,
                                                   seat_price: 2,
                                                   flight_id: flight.id,
                                                   user_id: user.id } }

        expect(response).to have_http_status(:created)
      end

      it 'creates and returns a new booking' do
        post '/api/bookings', params: { booking: { no_of_seats: 1,
                                                   seat_price: 2,
                                                   flight_id: flight.id,
                                                   user_id: user.id } }

        json_body = JSON.parse(response.body)
        expect(json_body).to include('booking' => include('seat_price' => 2))
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        post '/api/bookings', params: { booking: { seat_price: '' } }

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns all errors' do
        post '/api/bookings', params: { booking: { seat_price: '' } }

        json_body = JSON.parse(response.body)
        expect(json_body).to include('errors')
      end
    end
  end

  describe 'PATCH #update' do
    let(:booking) { FactoryBot.create(:booking) }

    context 'when params are valid' do
      it 'returns 200 OK' do
        put "/api/bookings/#{booking.id}",
            params: { id: booking.id, booking: { seat_price: 5 } }

        expect(response).to have_http_status(:success)
      end

      it 'returns a created booking' do
        put "/api/bookings/#{booking.id}",
            params: { id: booking.id, booking: { seat_price: 25 } }

        json_body = JSON.parse(response.body)
        expect(json_body).to include('booking' => include('seat_price' => 25))
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        put "/api/bookings/#{booking.id}",
            params: { id: booking.id, booking: { seat_price: '' } }

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns all errors' do
        put "/api/bookings/#{booking.id}",
            params: { id: booking.id, booking: { seat_price: '' } }

        json_body = JSON.parse(response.body)
        expect(json_body).to include('errors')
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:booking) { FactoryBot.create(:booking) }

    it 'returns 204 No Content' do
      delete "/api/bookings/#{booking.id}", params: { id: booking.id }

      expect(response).to have_http_status(:no_content)
    end
  end
end
