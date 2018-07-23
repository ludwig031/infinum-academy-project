RSpec.describe BookingsController, type: :controller do
  describe 'GET #index' do
    let(:bookings) { FactoryBot.create_list(:booking) }

    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'returns list of bookings' do
      get :index
      expect(response).to be_success
    end
  end

  describe 'GET #show' do
    let(:booking) { FactoryBot.create(:booking) }

    it 'returns http success' do
      get :show, params: { id: booking.id }
      expect(response).to have_http_status(:success)
    end

    it 'returns a single booking' do
      get :show, params: { id: booking.id }
      json_body = JSON.parse(response.body)
      expect(json_body).to include('booking')
    end
  end

  describe 'POST #create' do
    context 'when params are valid' do
      let(:flight) { FactoryBot.create(:flight) }
      let(:user) { FactoryBot.create(:user) }

      it 'returns 201' do
        post :create, params: { booking: { no_of_seats: 1,
                                           seat_price: 2,
                                           flight_id: flight.id,
                                           user_id: user.id } }

        expect(response).to have_http_status(:created)
      end

      it 'creates and returns a new booking' do
        post :create, params: { booking: { no_of_seats: 1,
                                           seat_price: 2,
                                           flight_id: flight.id,
                                           user_id: user.id } }

        json_body = JSON.parse(response.body)
        expect(json_body).to include('booking' => include('seat_price' => 2))
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        post :create, params: { booking: { seat_price: '' } }

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns all errors' do
        post :create, params: { booking: { seat_price: '' } }

        json_body = JSON.parse(response.body)
        expect(json_body).to include('errors')
      end
    end
  end

  describe 'PATCH #update' do
    let(:booking) { FactoryBot.create(:booking) }

    context 'when params are valid' do
      it 'returns 200 OK' do
        post :update, params: { id: booking.id,
                                booking: { seat_price: 5 } }

        expect(response).to have_http_status(:success)
      end

      it 'returns a created booking' do
        post :update, params: { id: booking.id,
                                booking: { seat_price: 25 } }

        json_body = JSON.parse(response.body)
        expect(json_body).to include('booking' => include('seat_price' => 25))
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        post :update, params: { id: booking.id,
                                booking: { seat_price: '' } }

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns all errors' do
        post :update, params: { id: booking.id,
                                booking: { seat_price: '' } }

        json_body = JSON.parse(response.body)
        expect(json_body).to include('errors')
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:booking) { FactoryBot.create(:booking) }

    it 'returns 204 No Content' do
      post :destroy, params: { id: booking.id }

      expect(response).to have_http_status(:no_content)
    end
  end
end
