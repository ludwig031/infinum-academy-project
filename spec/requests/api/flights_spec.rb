RSpec.describe 'Flights API', type: :request do
  include TestHelpers::JsonResponse

  let!(:user) { FactoryBot.create(:user) }

  describe 'GET #index' do
    let(:flights) { FactoryBot.create_list(:flight, 3) }

    before { flights }

    it 'returns http success' do
      get '/api/flights', headers: { Authorization: user.token }
      expect(response).to have_http_status(:ok)
    end

    it 'returns list of all active flights' do
      get '/api/flights', headers: { Authorization: user.token }
      expect(json_body['flights'].length).to eq 3
    end

    it 'returns sorted flights' do
      get '/api/flights', headers: { Authorization: user.token }

      expect(json_body['flights']).to eq(json_body['flights']
                                             .sort_by { |o| o['flys_at'] }
                                             .sort_by { |o| o['name'] }
                                             .sort_by { |o| o['created_at'] })
    end

    it 'returns no_of_booked_seats' do
      get '/api/flights', headers: { Authorization: user.token }

      expect(json_body['flights'][0]).to include('no_of_booked_seats')
    end

    it 'returns company_name' do
      get '/api/flights', headers: { Authorization: user.token }

      expect(json_body['flights'][0]).to include('company_name')
    end

    it 'returns current_price' do
      get '/api/flights', headers: { Authorization: user.token }

      expect(json_body['flights'][0]).to include('current_price')
    end

    it 'returns current_price correctly' do
      get '/api/flights', headers: { Authorization: user.token }

      seat_price = (flights.first.base_price * (25.0 / 15)).round
      expect(json_body['flights'][0]['current_price']).to eq(seat_price)
    end

    context 'when unauthenticated' do
      it 'fails' do
        get '/api/flights', headers: { Authorization: '' }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'responds with errors' do
        get '/api/flights', headers: { Authorization: '' }
        expect(json_body)
          .to include('errors' => include('token' => ['is invalid']))
      end
    end
  end

  describe 'GET /api/flights?company_id=' do
    let(:flights) { FactoryBot.create_list(:flight, 3) }

    before do
      flights
    end

    it 'successfully returns list of flights' do
      get "/api/flights?company_id=#{flights.first.company_id}",
          headers: { Authorization: user.token }

      expect(response).to have_http_status(:ok)
    end

    it 'returns 2 flights' do
      get "/api/flights?company_id=#{flights.first.company_id},
           #{flights.last.company_id}",
          headers: { Authorization: user.token }

      expect(json_body['flights'].length).to eq(2)
    end
  end

  describe 'GET #show' do
    let(:flight) { FactoryBot.create(:flight) }

    it 'returns http success' do
      get "/api/flights/#{flight.id}", headers: { Authorization: user.token }
      expect(response).to have_http_status(:ok)
    end

    it 'returns a single flight' do
      get "/api/flights/#{flight.id}", headers: { Authorization: user.token }
      expect(json_body).to include('flight')
    end

    context 'when unauthenticated' do
      it 'fails' do
        get "/api/flights/#{flight.id}", headers: { Authorization: '' }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'responds with errors' do
        get "/api/flights/#{flight.id}", headers: { Authorization: '' }
        expect(json_body)
          .to include('errors' => include('token' => ['is invalid']))
      end
    end
  end

  describe 'POST #create' do
    context 'when params are valid' do
      let(:company) { FactoryBot.create(:company) }

      it 'returns 201' do
        post '/api/flights',
             params: { flight: {  name: 'Let za doma',
                                  flys_at: 1.hour.from_now,
                                  lands_at: 2.hours.from_now,
                                  base_price: 100,
                                  no_of_seats: 200,
                                  company_id: company.id } },
             headers: { Authorization: user.token }

        expect(response).to have_http_status(:created)
      end

      it 'changes flights count by one' do
        expect do
          post '/api/flights',
               params: { flight: {  name: 'Let za doma',
                                    flys_at: 1.hour.from_now,
                                    lands_at: 2.hours.from_now,
                                    base_price: 100,
                                    no_of_seats: 200,
                                    company_id: company.id } },
               headers: { Authorization: user.token }
        end.to change(Flight, :count).by(+1)
      end

      it 'creates and returns a new flight' do
        post '/api/flights',
             params: { flight: { name: 'Drugi let za doma',
                                 flys_at: 1.hour.from_now,
                                 lands_at: 2.hours.from_now,
                                 base_price: 100,
                                 no_of_seats: 200,
                                 company_id: company.id } },
             headers: { Authorization: user.token }

        expect(json_body).to include('flight' =>
                                         include('name' => 'Drugi let za doma'))
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        post '/api/flights',
             params: { flight: { name: '' } },
             headers: { Authorization: user.token }

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns all errors' do
        post '/api/flights',
             params: { flight: { name: '' } },
             headers: { Authorization: user.token }

        expect(json_body).to include('errors')
      end

      it 'flights from same company are overlaping' do
        first = FactoryBot.create(:flight)
        post '/api/flights',
             params: { flight: { name: 'flight_name', no_of_seats: 10,
                                 base_price: 100, flys_at: first.flys_at,
                                 lands_at: first.lands_at,
                                 company_id: first.company_id } },
             headers: { Authorization: user.token }

        expect(json_body['errors']).to include('flys_at')
      end
    end

    context 'when unauthenticated' do
      it 'fails' do
        post '/api/flights', headers: { Authorization: '' }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'responds with errors' do
        post '/api/flights', headers: { Authorization: '' }
        expect(json_body)
          .to include('errors' => include('token' => ['is invalid']))
      end
    end
  end

  describe 'PATCH #update' do
    let(:flight) { FactoryBot.create(:flight) }

    context 'when params are valid' do
      it 'returns 200 OK' do
        put "/api/flights/#{flight.id}",
            params: { flight: { name: 'Lufthansa' } },
            headers: { Authorization: user.token }

        expect(response).to have_http_status(:ok)
      end

      it 'returns a created booking' do
        put "/api/flights/#{flight.id}",
            params: { flight: { name: 'Ryanair' } },
            headers: { Authorization: user.token }

        expect(json_body).to include('flight' => include('name' => 'Ryanair'))
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        put "/api/flights/#{flight.id}",
            params: { flight: { name: '' } },
            headers: { Authorization: user.token }

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns all errors' do
        put "/api/flights/#{flight.id}",
            params: { flight: { name: '' } },
            headers: { Authorization: user.token }

        expect(json_body).to include('errors')
      end
    end

    context 'when unauthenticated' do
      it 'fails' do
        put "/api/flights/#{flight.id}", headers: { Authorization: '' }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'responds with errors' do
        put "/api/flights/#{flight.id}", headers: { Authorization: '' }
        expect(json_body)
          .to include('errors' => include('token' => ['is invalid']))
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:flight) { FactoryBot.create(:flight) }

    it 'returns 204 No Content' do
      delete "/api/flights/#{flight.id}",
             headers: { Authorization: user.token }

      expect(response).to have_http_status(:no_content)
    end

    it 'decrements flights count by one' do
      flight
      expect do
        delete "/api/flights/#{flight.id}",
               headers: { Authorization: user.token }
      end.to change(Flight, :count).by(-1)
    end

    context 'when unauthenticated' do
      it 'fails' do
        delete "/api/flights/#{flight.id}", headers: { Authorization: '' }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'responds with errors' do
        delete "/api/flights/#{flight.id}", headers: { Authorization: '' }
        expect(json_body)
          .to include('errors' => include('token' => ['is invalid']))
      end
    end
  end
end
