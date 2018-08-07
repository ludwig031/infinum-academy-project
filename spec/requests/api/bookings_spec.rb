RSpec.describe 'Bookings API', type: :request do
  include TestHelpers::JsonResponse

  let(:user) { FactoryBot.create(:user) }

  before { user }

  describe 'GET #index' do
    let(:bookings) { FactoryBot.create_list(:booking, 3, user: user) }

    before { bookings }

    it 'returns http success' do
      get '/api/bookings', headers: { Authorization: user.token }
      expect(response).to have_http_status(:ok)
    end

    it 'returns list of bookings' do
      get '/api/bookings', headers: { Authorization: user.token }
      expect(json_body['bookings'].length).to eq 3
    end

    it 'returns sorted bookings' do
      get '/api/bookings', headers: { Authorization: user.token }

      expect(json_body['bookings'])
        .to eq(json_body['bookings']
                     .sort_by { |o| o['flight']['flys_at'] }
                     .sort_by { |o| o['flight']['name'] }
                     .sort_by { |o| o['created_at'] })
    end

    it 'contains total_price' do
      get '/api/bookings', headers: { Authorization: user.token }

      expect(json_body['bookings'][0]).to include('total_price')
    end

    it 'contains flight' do
      get '/api/bookings', headers: { Authorization: user.token }

      expect(json_body['bookings'][0]).to include('flight')
    end

    context 'when unauthenticated' do
      it 'fails' do
        get '/api/bookings', headers: { Authorization: '' }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'responds with errors' do
        get '/api/bookings', headers: { Authorization: '' }
        expect(json_body['errors']).to include('token' => ['is invalid'])
      end
    end
  end

  describe 'GET #show' do
    let(:booking) { FactoryBot.create(:booking, user: user) }

    it 'returns http success' do
      get "/api/bookings/#{booking.id}", headers: { Authorization: user.token }
      expect(response).to have_http_status(:ok)
    end

    it 'returns a single booking' do
      get "/api/bookings/#{booking.id}", headers: { Authorization: user.token }
      expect(json_body).to include('booking')
    end

    context 'when unauthenticated' do
      it 'fails' do
        get "/api/bookings/#{booking.id}", headers: { Authorization: '' }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'responds with errors' do
        get "/api/bookings/#{booking.id}", headers: { Authorization: '' }
        expect(json_body['errors']).to include('token' => ['is invalid'])
      end
    end

    context 'when authenticated but unauthorized' do
      let(:another_user) { FactoryBot.create(:user) }

      before { another_user }

      it 'fails' do
        get "/api/bookings/#{booking.id}",
            headers: { Authorization: another_user.token }

        expect(response).to have_http_status(:forbidden)
      end

      it 'responds with errors' do
        get "/api/bookings/#{booking.id}",
            headers: { Authorization: another_user.token }

        expect(json_body['errors']).to include('resource' => ['is forbidden'])
      end
    end
  end

  describe 'POST #create' do
    context 'when params are valid' do
      let(:flight) { FactoryBot.create(:flight) }
      let(:user) { FactoryBot.create(:user) }

      it 'returns 201' do
        post '/api/bookings',
             params: { booking: { no_of_seats: 1,
                                  seat_price: 2,
                                  flight_id: flight.id,
                                  user: user } },
             headers: { Authorization: user.token }

        expect(response).to have_http_status(:created)
      end

      it 'changes bookings count by one' do
        expect do
          post '/api/bookings',
               params: { booking: { no_of_seats: 1,
                                    seat_price: 2,
                                    flight_id: flight.id,
                                    user: user } },
               headers: { Authorization: user.token }
        end.to change(Booking, :count).by(+1)
      end

      it 'creates and returns a new booking' do
        post '/api/bookings',
             params: { booking: { no_of_seats: 1,
                                  seat_price: 2,
                                  flight_id: flight.id,
                                  user: user } },
             headers: { Authorization: user.token }

        expect(json_body['booking']).to include('no_of_seats' => 1)
      end
    end

    context 'when params are invalid' do
      let(:flight) { FactoryBot.create(:flight) }
      let(:user) { FactoryBot.create(:user) }

      it 'returns 400 Bad Request' do
        post '/api/bookings',
             params: { booking: { seat_price: '' } },
             headers: { Authorization: user.token }

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns all errors' do
        post '/api/bookings',
             params: { booking: { seat_price: '' } },
             headers: { Authorization: user.token }

        expect(json_body).to include('errors')
      end

      it 'flight is overbooked' do
        post '/api/bookings',
             params: { booking: { flight_id: flight.id,
                                  no_of_seats: flight.no_of_seats + 1 } },
             headers: { Authorization: user.token }

        expect(json_body['errors']).to include('flight')
      end
    end

    context 'when unauthenticated' do
      it 'fails' do
        post '/api/bookings', headers: { Authorization: '' }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'responds with errors' do
        post '/api/bookings', headers: { Authorization: '' }
        expect(json_body['errors']).to include('token' => ['is invalid'])
      end
    end
  end

  describe 'PATCH #update' do
    let(:booking) { FactoryBot.create(:booking, user: user) }

    context 'when params are valid' do
      it 'returns 200 OK' do
        put "/api/bookings/#{booking.id}",
            params: { booking: { no_of_seats: 1 } },
            headers: { Authorization: user.token }

        expect(response).to have_http_status(:ok)
      end

      it 'returns a created booking' do
        put "/api/bookings/#{booking.id}",
            params: { booking: { no_of_seats: 1 } },
            headers: { Authorization: user.token }

        expect(json_body['booking']).to include('no_of_seats' => 1)
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        put "/api/bookings/#{booking.id}",
            params: { booking: { no_of_seats: '' } },
            headers: { Authorization: user.token }

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns all errors' do
        put "/api/bookings/#{booking.id}",
            params: { booking: { no_of_seats: '' } },
            headers: { Authorization: user.token }

        expect(json_body).to include('errors')
      end
    end

    context 'when unauthenticated' do
      it 'fails' do
        put "/api/bookings/#{booking.id}", headers: { Authorization: '' }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'responds with errors' do
        put "/api/bookings/#{booking.id}", headers: { Authorization: '' }
        expect(json_body['errors']).to include('token' => ['is invalid'])
      end
    end

    context 'when authenticated but unauthorized' do
      let(:another_user) { FactoryBot.create(:user) }

      before { another_user }

      it 'fails' do
        put "/api/bookings/#{booking.id}",
            params: { booking: { seat_price: 5 } },
            headers: { Authorization: another_user.token }

        expect(response).to have_http_status(:forbidden)
      end

      it 'responds with errors' do
        put "/api/bookings/#{booking.id}",
            params: { booking: { seat_price: 5 } },
            headers: { Authorization: another_user.token }

        expect(json_body['errors']).to include('resource' => ['is forbidden'])
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:booking) { FactoryBot.create(:booking, user: user) }

    it 'returns 204 No Content' do
      delete "/api/bookings/#{booking.id}",
             headers: { Authorization: user.token }

      expect(response).to have_http_status(:no_content)
    end

    it 'decrements bookings count by one' do
      booking
      expect do
        delete "/api/bookings/#{booking.id}",
               headers: { Authorization: user.token }
      end.to change(Booking, :count).by(-1)
    end

    context 'when unauthenticated' do
      it 'fails' do
        delete "/api/bookings/#{booking.id}", headers: { Authorization: '' }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'responds with errors' do
        delete "/api/bookings/#{booking.id}", headers: { Authorization: '' }
        expect(json_body['errors']).to include('token' => ['is invalid'])
      end
    end

    context 'when authenticated but unauthorized' do
      let(:another_user) { FactoryBot.create(:user) }

      before { another_user }

      it 'fails' do
        delete "/api/bookings/#{booking.id}",
               headers: { Authorization: another_user.token }

        expect(response).to have_http_status(:forbidden)
      end

      it 'responds with errors' do
        delete "/api/bookings/#{booking.id}",
               headers: { Authorization: another_user.token }

        expect(json_body['errors']).to include('resource' => ['is forbidden'])
      end
    end
  end
end
