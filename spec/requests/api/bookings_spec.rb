RSpec.describe 'Bookings API', type: :request do
  include TestHelpers::JsonResponse

  let!(:user) { FactoryBot.create(:user) }

  before { user }

  describe 'GET #index' do
    let(:bookings) { FactoryBot.create_list(:booking, 3, user_id: user.id) }

    before { bookings }

    it 'returns http success' do
      get '/api/bookings', headers: { Authorization: user.token }
      expect(response).to have_http_status(:ok)
    end

    it 'returns list of bookings' do
      get '/api/bookings', headers: { Authorization: user.token }
      expect(json_body['bookings'].length).to eq 3
    end

    context 'when unauthenticated' do
      it 'fails' do
        get '/api/bookings', headers: { Authorization: '' }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'responds with errors' do
        get '/api/bookings', headers: { Authorization: '' }
        expect(json_body)
          .to include('errors' => include('token' => ['is invalid']))
      end
    end
  end

  describe 'GET #show' do
    let(:booking) { FactoryBot.create(:booking, user_id: user.id) }

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
        expect(json_body)
          .to include('errors' => include('token' => ['is invalid']))
      end
    end

    context 'when authenticated but unauthorized' do
      let(:user2) { FactoryBot.create(:user) }

      before { user2 }

      it 'fails' do
        get "/api/bookings/#{booking.id}",
            headers: { Authorization: user2.token }

        expect(response).to have_http_status(:forbidden)
      end

      it 'responds with errors' do
        get "/api/bookings/#{booking.id}",
            headers: { Authorization: user2.token }

        expect(json_body)
          .to include('errors' => include('resource' => ['is forbidden']))
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
                                  user_id: user.id } },
             headers: { Authorization: user.token }

        expect(response).to have_http_status(:created)
      end

      it 'changes bookings count by one' do
        expect do
          post '/api/bookings',
               params: { booking: { no_of_seats: 1,
                                    seat_price: 2,
                                    flight_id: flight.id,
                                    user_id: user.id } },
               headers: { Authorization: user.token }
        end.to change(Booking, :count).by(+1)
      end

      it 'creates and returns a new booking' do
        post '/api/bookings',
             params: { booking: { no_of_seats: 1,
                                  seat_price: 2,
                                  flight_id: flight.id,
                                  user_id: user.id } },
             headers: { Authorization: user.token }

        expect(json_body).to include('booking' => include('seat_price' => 2))
      end
    end

    context 'when params are invalid' do
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
    end

    context 'when unauthenticated' do
      it 'fails' do
        post '/api/bookings', headers: { Authorization: '' }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'responds with errors' do
        post '/api/bookings', headers: { Authorization: '' }
        expect(json_body)
          .to include('errors' => include('token' => ['is invalid']))
      end
    end
  end

  describe 'PATCH #update' do
    let(:booking) { FactoryBot.create(:booking, user_id: user.id) }

    context 'when params are valid' do
      it 'returns 200 OK' do
        put "/api/bookings/#{booking.id}",
            params: { booking: { seat_price: 5 } },
            headers: { Authorization: user.token }

        expect(response).to have_http_status(:ok)
      end

      it 'returns a created booking' do
        put "/api/bookings/#{booking.id}",
            params: { booking: { seat_price: 25 } },
            headers: { Authorization: user.token }

        expect(json_body).to include('booking' => include('seat_price' => 25))
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        put "/api/bookings/#{booking.id}",
            params: { booking: { seat_price: '' } },
            headers: { Authorization: user.token }

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns all errors' do
        put "/api/bookings/#{booking.id}",
            params: { booking: { seat_price: '' } },
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
        expect(json_body)
          .to include('errors' => include('token' => ['is invalid']))
      end
    end

    context 'when authenticated but unauthorized' do
      let(:user2) { FactoryBot.create(:user) }

      before { user2 }

      it 'fails' do
        put "/api/bookings/#{booking.id}",
            params: { booking: { seat_price: 5 } },
            headers: { Authorization: user2.token }

        expect(response).to have_http_status(:forbidden)
      end

      it 'responds with errors' do
        put "/api/bookings/#{booking.id}",
            params: { booking: { seat_price: 5 } },
            headers: { Authorization: user2.token }

        expect(json_body)
          .to include('errors' => include('resource' => ['is forbidden']))
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:booking) { FactoryBot.create(:booking, user_id: user.id) }

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
        expect(json_body)
          .to include('errors' => include('token' => ['is invalid']))
      end
    end

    context 'when authenticated but unauthorized' do
      let(:user2) { FactoryBot.create(:user) }

      before { user2 }

      it 'fails' do
        delete "/api/bookings/#{booking.id}",
               headers: { Authorization: user2.token }

        expect(response).to have_http_status(:forbidden)
      end

      it 'responds with errors' do
        delete "/api/bookings/#{booking.id}",
               headers: { Authorization: user2.token }

        expect(json_body)
          .to include('errors' => include('resource' => ['is forbidden']))
      end
    end
  end
end
