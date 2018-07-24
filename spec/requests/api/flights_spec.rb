RSpec.describe 'Flights API', type: :request do
  include TestHelpers::JsonResponse

  describe 'GET #index' do
    let(:flights) { FactoryBot.create_list(:flight, 3) }

    before { flights }

    it 'returns http success' do
      get '/api/flights'
      expect(response).to have_http_status(:success)
    end

    it 'returns list of flights' do
      get '/api/flights'
      expect(json_body['flights'].length).to eq 3
    end
  end

  describe 'GET #show' do
    let(:flight) { FactoryBot.create(:flight) }

    it 'returns http success' do
      get "/api/flights/#{flight.id}", params: { id: flight.id }
      expect(response).to have_http_status(:success)
    end

    it 'returns a single flight' do
      get "/api/flights/#{flight.id}", params: { id: flight.id }
      expect(json_body).to include('flight')
    end
  end

  describe 'POST #create' do
    context 'when params are valid' do
      let(:company) { FactoryBot.create(:company) }

      it 'returns 201' do
        post '/api/flights',
             params: { flight: {  name: 'Let za doma',
                                  flys_at: Time.zone.now + 1.hour,
                                  lands_at: Time.zone.now + 2.hours,
                                  base_price: 100,
                                  no_of_seats: 200,
                                  company_id: company.id } }

        expect(response).to have_http_status(:created)
      end

      it 'creates and returns a new flight' do
        post '/api/flights',
             params: { flight: { name: 'Drugi let za doma',
                                 flys_at: Time.zone.now + 1.hour,
                                 lands_at: Time.zone.now + 2.hours,
                                 base_price: 100,
                                 no_of_seats: 200,
                                 company_id: company.id } }

        expect(json_body).to include('flight' =>
                                         include('name' => 'Drugi let za doma'))
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        post '/api/flights', params: { flight: { name: '' } }

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns all errors' do
        post '/api/flights', params: { flight: { name: '' } }

        expect(json_body).to include('errors')
      end
    end
  end

  describe 'PATCH #update' do
    let(:flight) { FactoryBot.create(:flight) }

    context 'when params are valid' do
      it 'returns 200 OK' do
        put "/api/flights/#{flight.id}",
            params: { id: flight.id, flight: { name: 'Lufthansa' } }

        expect(response).to have_http_status(:success)
      end

      it 'returns a created booking' do
        put "/api/flights/#{flight.id}",
            params: { id: flight.id, flight: { name: 'Ryanair' } }

        expect(json_body).to include('flight' => include('name' => 'Ryanair'))
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        put "/api/flights/#{flight.id}",
            params: { id: flight.id, flight: { name: '' } }

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns all errors' do
        put "/api/flights/#{flight.id}",
            params: { id: flight.id, flight: { name: '' } }

        expect(json_body).to include('errors')
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:flight) { FactoryBot.create(:flight) }

    it 'returns 204 No Content' do
      delete "/api/flights/#{flight.id}", params: { id: flight.id }

      expect(response).to have_http_status(:no_content)
    end
  end
end
