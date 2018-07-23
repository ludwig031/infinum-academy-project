RSpec.describe FlightsController, type: :controller do
  describe 'GET #index' do
    let(:flights) { FactoryBot.create_list(:flight) }

    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'returns list of flights' do
      get :index
      expect(response).to be_success
    end
  end

  describe 'GET #show' do
    let(:flight) { FactoryBot.create(:flight) }

    it 'returns http success' do
      get :show, params: { id: flight.id }
      expect(response).to have_http_status(:success)
    end

    it 'returns a single flight' do
      get :show, params: { id: flight.id }
      json_body = JSON.parse(response.body)
      expect(json_body).to include('flight')
    end
  end

  describe 'POST #create' do
    context 'when params are valid' do
      let(:company) { FactoryBot.create(:company) }

      it 'returns 201' do
        post :create, params: { flight: { name: 'Let za doma',
                                          flys_at: Time.zone.now + 1.hour,
                                          lands_at: Time.zone.now + 2.hours,
                                          base_price: 100,
                                          no_of_seats: 200,
                                          company_id: company.id } }

        expect(response).to have_http_status(:created)
      end

      it 'creates and returns a new flight' do
        post :create, params: { flight: { name: 'Drugi let za doma',
                                          flys_at: Time.zone.now + 1.hour,
                                          lands_at: Time.zone.now + 2.hours,
                                          base_price: 100,
                                          no_of_seats: 200,
                                          company_id: company.id } }

        json_body = JSON.parse(response.body)
        expect(json_body).to include('flight' =>
                                         include('name' => 'Drugi let za doma'))
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        post :create, params: { flight: { name: '' } }

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns all errors' do
        post :create, params: { flight: { name: '' } }

        json_body = JSON.parse(response.body)
        expect(json_body).to include('errors')
      end
    end
  end

  describe 'PATCH #update' do
    let(:flight) { FactoryBot.create(:flight) }

    context 'when params are valid' do
      it 'returns 200 OK' do
        post :update, params: { id: flight.id,
                                flight: { name: 'Lufthansa' } }

        expect(response).to have_http_status(:success)
      end

      it 'returns a created booking' do
        post :update, params: { id: flight.id,
                                flight: { name: 'Ryanair' } }

        json_body = JSON.parse(response.body)
        expect(json_body).to include('flight' => include('name' => 'Ryanair'))
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        post :update, params: { id: flight.id,
                                flight: { name: '' } }

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns all errors' do
        post :update, params: { id: flight.id,
                                flight: { name: '' } }

        json_body = JSON.parse(response.body)
        expect(json_body).to include('errors')
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:flight) { FactoryBot.create(:flight) }

    it 'returns 204 No Content' do
      post :destroy, params: { id: flight.id }

      expect(response).to have_http_status(:no_content)
    end
  end
end
