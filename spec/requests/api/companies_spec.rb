RSpec.describe 'Companies API', type: :request do
  include TestHelpers::JsonResponse

  let!(:user) { FactoryBot.create(:user) }

  describe 'GET #index' do
    let(:companies) { FactoryBot.create_list(:company, 3) }

    before { companies }

    it 'returns http success' do
      get '/api/companies', headers: { Authorization: user.token }
      expect(response).to have_http_status(:ok)
    end

    it 'returns list of companies' do
      get '/api/companies', headers: { Authorization: user.token }
      expect(json_body['companies'].length).to eq 3
    end

    it 'companies are sorted' do
      get '/api/companies', headers: { Authorization: user.token }

      expect(json_body['companies']).to eq(json_body['companies']
                                               .sort_by { |o| o['name'] })
    end

    it 'containes no_of_active_flights' do
      get '/api/companies',
          headers: { Authorization: user.token }

      expect(json_body['companies'][0]).to include('no_of_active_flights')
    end

    context 'when unauthenticated' do
      it 'fails' do
        get '/api/companies', headers: { Authorization: '' }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'responds with errors' do
        get '/api/companies', headers: { Authorization: '' }
        expect(json_body)
          .to include('errors' => include('token' => ['is invalid']))
      end
    end
  end

  describe 'GET #show' do
    let(:company) { FactoryBot.create(:company) }

    it 'returns http success' do
      get "/api/companies/#{company.id}", headers: { Authorization: user.token }
      expect(response).to have_http_status(:ok)
    end

    it 'returns a single company' do
      get "/api/companies/#{company.id}", headers: { Authorization: user.token }
      expect(json_body).to include('company')
    end

    context 'when unauthenticated' do
      it 'fails' do
        get "/api/companies/#{company.id}", headers: { Authorization: '' }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'responds with errors' do
        get "/api/companies/#{company.id}", headers: { Authorization: '' }
        expect(json_body)
          .to include('errors' => include('token' => ['is invalid']))
      end
    end
  end

  describe 'POST #create' do
    context 'when params are valid' do
      it 'returns 201' do
        post '/api/companies',
             params: { company: { name: 'Lufthansa' } },
             headers: { Authorization: user.token }

        expect(response).to have_http_status(:created)
      end

      it 'changes companies count by one' do
        expect do
          post '/api/companies',
               params: { company: { name: 'Lufthansa' } },
               headers: { Authorization: user.token }
        end.to change(Company, :count).by(+1)
      end

      it 'creates and returns a new company' do
        post '/api/companies',
             params: { company: { name: 'Ryanair' } },
             headers: { Authorization: user.token }

        expect(json_body).to include('company' => include('name' => 'Ryanair'))
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        post '/api/companies',
             params: { company: { name: '' } },
             headers: { Authorization: user.token }

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns all errors' do
        post '/api/companies',
             params: { company: { name: '' } },
             headers: { Authorization: user.token }

        expect(json_body).to include('errors')
      end
    end

    context 'when unauthenticated' do
      it 'fails' do
        post '/api/companies', headers: { Authorization: '' }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'responds with errors' do
        post '/api/companies', headers: { Authorization: '' }
        expect(json_body)
          .to include('errors' => include('token' => ['is invalid']))
      end
    end
  end

  describe 'PATCH #update' do
    let(:company) { FactoryBot.create(:company) }

    context 'when params are valid' do
      it 'returns 200 OK' do
        put "/api/companies/#{company.id}",
            params: { company: { name: 'Lufthansa' } },
            headers: { Authorization: user.token }

        expect(response).to have_http_status(:ok)
      end

      it 'returns a created booking' do
        put "/api/companies/#{company.id}",
            params: { company: { name: 'Ryanair' } },
            headers: { Authorization: user.token }

        expect(json_body).to include('company' => include('name' => 'Ryanair'))
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        put "/api/companies/#{company.id}",
            params: { company: { name: '' } },
            headers: { Authorization: user.token }

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns all errors' do
        put "/api/companies/#{company.id}",
            params: { company: { name: '' } },
            headers: { Authorization: user.token }

        expect(json_body).to include('errors')
      end
    end

    context 'when unauthenticated' do
      it 'fails' do
        put "/api/companies/#{company.id}", headers: { Authorization: '' }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'responds with errors' do
        put "/api/companies/#{company.id}", headers: { Authorization: '' }
        expect(json_body)
          .to include('errors' => include('token' => ['is invalid']))
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:company) { FactoryBot.create(:company) }

    it 'returns 204 No Content' do
      delete "/api/companies/#{company.id}",
             headers: { Authorization: user.token }

      expect(response).to have_http_status(:no_content)
    end

    it 'decrements companies count by one' do
      company
      expect do
        delete "/api/companies/#{company.id}",
               headers: { Authorization: user.token }
      end.to change(Company, :count).by(-1)
    end

    context 'when unauthenticated' do
      it 'fails' do
        delete "/api/companies/#{company.id}", headers: { Authorization: '' }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'responds with errors' do
        delete "/api/companies/#{company.id}", headers: { Authorization: '' }
        expect(json_body)
          .to include('errors' => include('token' => ['is invalid']))
      end
    end
  end
end
