RSpec.describe 'Companies API', type: :request do
  include TestHelpers::JsonResponse

  let!(:user) { FactoryBot.create(:user, token: 'abc-123') }

  describe 'GET #index' do
    let(:companies) { FactoryBot.create_list(:company, 3) }

    before { companies }

    it 'returns http success' do
      get '/api/companies', headers: { Authorization: 'abc-123' }
      expect(response).to have_http_status(:ok)
    end

    it 'returns list of companies' do
      get '/api/companies', headers: { Authorization: 'abc-123' }
      expect(json_body['companies'].length).to eq 3
    end
  end

  describe 'GET #show' do
    let(:company) { FactoryBot.create(:company) }

    it 'returns http success' do
      get "/api/companies/#{company.id}", headers: { Authorization: 'abc-123' }
      expect(response).to have_http_status(:ok)
    end

    it 'returns a single company' do
      get "/api/companies/#{company.id}", headers: { Authorization: 'abc-123' }
      expect(json_body).to include('company')
    end
  end

  describe 'POST #create' do
    context 'when params are valid' do
      it 'returns 201' do
        post '/api/companies', params: { company: { name: 'Lufthansa' } },
             headers: { Authorization: 'abc-123' }

        expect(response).to have_http_status(:created)
      end

      it 'changes companies count by one' do
        expect do
          post '/api/companies', params: { company: { name: 'Lufthansa' } },
               headers: { Authorization: 'abc-123' }
        end.to change(Company, :count).by(+1)
      end

      it 'creates and returns a new company' do
        post '/api/companies', params: { company: { name: 'Ryanair' } },
             headers: { Authorization: 'abc-123' }

        expect(json_body).to include('company' => include('name' => 'Ryanair'))
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        post '/api/companies', params: { company: { name: '' } },
             headers: { Authorization: 'abc-123' }

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns all errors' do
        post '/api/companies', params: { company: { name: '' } },
             headers: { Authorization: 'abc-123' }

        expect(json_body).to include('errors')
      end
    end
  end

  describe 'PATCH #update' do
    let(:company) { FactoryBot.create(:company) }

    context 'when params are valid' do
      it 'returns 200 OK' do
        put "/api/companies/#{company.id}",
            params: { company: { name: 'Lufthansa' } },
            headers: { Authorization: 'abc-123' }

        expect(response).to have_http_status(:ok)
      end

      it 'returns a created booking' do
        put "/api/companies/#{company.id}",
            params: { company: { name: 'Ryanair' } },
            headers: { Authorization: 'abc-123' }

        expect(json_body).to include('company' => include('name' => 'Ryanair'))
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        put "/api/companies/#{company.id}",
            params: { company: { name: '' } },
            headers: { Authorization: 'abc-123' }

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns all errors' do
        put "/api/companies/#{company.id}",
            params: { company: { name: '' } },
            headers: { Authorization: 'abc-123' }

        expect(json_body).to include('errors')
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:company) { FactoryBot.create(:company) }

    it 'returns 204 No Content' do
      delete "/api/companies/#{company.id}",
             headers: { Authorization: 'abc-123' }

      expect(response).to have_http_status(:no_content)
    end

    it 'decrements companies count by one' do
      company
      expect do
        delete "/api/companies/#{company.id}",
               headers: { Authorization: 'abc-123' }
      end.to change(Company, :count).by(-1)
    end
  end
end
