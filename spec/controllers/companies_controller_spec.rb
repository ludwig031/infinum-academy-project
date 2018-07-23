RSpec.describe CompaniesController, type: :controller do
  describe 'GET #index' do
    let(:companies) { FactoryBot.create_list(:company) }

    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'returns list of companies' do
      get :index
      expect(response).to be_success
    end
  end

  describe 'GET #show' do
    let(:company) { FactoryBot.create(:company) }

    it 'returns http success' do
      get :show, params: { id: company.id }
      expect(response).to have_http_status(:success)
    end

    it 'returns a single company' do
      get :show, params: { id: company.id }
      json_body = JSON.parse(response.body)
      expect(json_body).to include('company')
    end
  end

  describe 'POST #create' do
    context 'when params are valid' do
      it 'returns 201' do
        post :create, params: { company: { name: 'Lufthansa' } }

        expect(response).to have_http_status(:created)
      end

      it 'creates and returns a new company' do
        post :create, params: { company: { name: 'Ryanair' } }

        json_body = JSON.parse(response.body)
        expect(json_body).to include('company' => include('name' => 'Ryanair'))
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        post :create, params: { company: { name: '' } }

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns all errors' do
        post :create, params: { company: { name: '' } }

        json_body = JSON.parse(response.body)
        expect(json_body).to include('errors')
      end
    end
  end

  describe 'PATCH #update' do
    let(:company) { FactoryBot.create(:company) }

    context 'when params are valid' do
      it 'returns 200 OK' do
        post :update, params: { id: company.id,
                                company: { name: 'Lufthansa' } }

        expect(response).to have_http_status(:success)
      end

      it 'returns a created booking' do
        post :update, params: { id: company.id,
                                company: { name: 'Ryanair' } }

        json_body = JSON.parse(response.body)
        expect(json_body).to include('company' => include('name' => 'Ryanair'))
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        post :update, params: { id: company.id,
                                company: { name: '' } }

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns all errors' do
        post :update, params: { id: company.id,
                                company: { name: '' } }

        json_body = JSON.parse(response.body)
        expect(json_body).to include('errors')
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:company) { FactoryBot.create(:company) }

    it 'returns 204 No Content' do
      post :destroy, params: { id: company.id }

      expect(response).to have_http_status(:no_content)
    end
  end
end
