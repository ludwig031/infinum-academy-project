RSpec.describe 'Users API', type: :request do
  include TestHelpers::JsonResponse

  describe 'GET #index' do
    let(:users) { FactoryBot.create_list(:user, 3) }

    before { users }

    it 'returns http success' do
      get '/api/users', headers: { Authorization: users[0].token }
      expect(response).to have_http_status(:ok)
    end

    it 'returns list of users' do
      get '/api/users', headers: { Authorization: users[0].token }
      expect(json_body['users'].length).to eq 3
    end

    it 'returns sorted users' do
      get '/api/users', headers: { Authorization: users.first.token }

      expect(json_body['users']).to eq(json_body['users']
                                           .sort_by { |o| o['email'] })
    end

    it 'contanies bookings association' do
      get '/api/users', headers: { Authorization: users.first.token }

      expect(json_body['users'][0]).to include('bookings')
    end

    context 'when unauthenticated' do
      it 'fails' do
        get '/api/users', headers: { Authorization: '' }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'responds with errors' do
        get '/api/users', headers: { Authorization: '' }
        expect(json_body)
          .to include('errors' => include('token' => ['is invalid']))
      end
    end

    describe 'when query provided responds with users' do
      let(:first) do
        FactoryBot.create(:user, first_name: 'Borna',
                                 last_name: 'Matijanic',
                                 email: 'borna@mail.com')
      end
      let(:second) do
        FactoryBot.create(:user, first_name: 'Imen',
                                 last_name: 'Prezimenic',
                                 email: 'imen@mail.com')
      end

      before do
        first
        second
      end

      it 'returns status code 200' do
        get '/api/users?query=a',
            headers: { Authorization: first.token }
        expect(response).to have_http_status(:ok)
      end

      it 'successfully matches both' do
        get '/api/users?query=ic',
            headers: { Authorization: first.token }

        expect(json_body['users'].length).to eq(2)
      end

      it 'successfully matches first_name' do
        get '/api/users?query=borN',
            headers: { Authorization: first.token }

        expect(json_body['users'].length).to eq(1)
      end
    end
  end

  describe 'GET #show' do
    let(:user) { FactoryBot.create(:user) }

    it 'returns http success' do
      get "/api/users/#{user.id}", headers: { Authorization: user.token }

      expect(response).to have_http_status(:ok)
    end

    it 'returns a single user' do
      get "/api/users/#{user.id}", headers: { Authorization: user.token }

      expect(json_body).to include('user')
    end

    context 'when unauthenticated' do
      it 'fails' do
        get "/api/users/#{user.id}", headers: { Authorization: '' }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'responds with errors' do
        get "/api/users/#{user.id}", headers: { Authorization: '' }
        expect(json_body['errors']).to include('token' => ['is invalid'])
      end
    end

    context 'when authenticated but unauthorized' do
      let(:another_user) { FactoryBot.create(:user) }

      before { another_user }

      it 'fails' do
        get "/api/users/#{another_user.id}",
            headers: { Authorization: user.token }

        expect(response).to have_http_status(:forbidden)
      end

      it 'responds with errors' do
        get "/api/users/#{another_user.id}",
            headers: { Authorization: user.token }

        expect(json_body['errors']).to include('resource' => ['is forbidden'])
      end
    end
  end

  describe 'POST #create' do
    context 'when params are valid' do
      it 'returns 201' do
        post '/api/users',
             params: { user: { first_name: 'Ljudevit',
                               last_name: 'Ludwig',
                               email: 'mail-1@mail.com',
                               password: 'Lozinka' } }

        expect(response).to have_http_status(:created)
      end

      it 'changes users count by one' do
        expect do
          post '/api/users',
               params: { user: { first_name: 'Ljudevit',
                                 last_name: 'Ludwig',
                                 email: 'mail-2@mail.com',
                                 password: 'Lozinka' } }
        end.to change(User, :count).by(+1)
      end

      it 'creates and returns a new user' do
        post '/api/users',
             params: { user: { first_name: 'Ljudevit',
                               last_name: 'Ludwig',
                               email: 'mail-3@mail.com',
                               password: 'Lozinka' } }

        expect(json_body['user']).to include('last_name' => 'Ludwig')
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        post '/api/users', params: { user: { first_name: '' } }

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns all errors' do
        post '/api/users', params: { user: { first_name: '' } }

        expect(json_body).to include('errors')
      end
    end
  end

  describe 'PATCH #update' do
    let(:user) { FactoryBot.create(:user) }

    context 'when params are valid password is changed' do
      it 'returns 200 OK' do
        put "/api/users/#{user.id}",
            params: { user: { password: 'New' } },
            headers: { Authorization: user.token }

        expect(response).to have_http_status(:ok)
      end

      it 'returns a updated user' do
        put "/api/users/#{user.id}",
            params: { user: { first_name: 'Ime' } },
            headers: { Authorization: user.token }

        expect(json_body['user']).to include('first_name' => 'Ime')
      end
    end

    context 'when password is nill' do
      it 'returns 400 Bad Request' do
        put "/api/users/#{user.id}",
            params: { user: { password: nil } },
            headers: { Authorization: user.token }

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns all errors' do
        put "/api/users/#{user.id}",
            params: { user: { password: nil } },
            headers: { Authorization: user.token }

        expect(json_body).to include('errors')
      end
    end

    context 'when unauthenticated' do
      it 'fails' do
        put "/api/users/#{user.id}", headers: { Authorization: '' }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'responds with errors' do
        put "/api/users/#{user.id}", headers: { Authorization: '' }
        expect(json_body['errors']).to include('token' => ['is invalid'])
      end
    end

    context 'when authenticated but unauthorized' do
      let(:another_user) { FactoryBot.create(:user) }

      before { another_user }

      it 'fails' do
        put "/api/users/#{another_user.id}",
            params: { user: { id: another_user.id, first_name: 'novo ime' } },
            headers: { Authorization: user.token }

        expect(response).to have_http_status(:forbidden)
      end

      it 'responds with errors' do
        put "/api/users/#{another_user.id}",
            params: { user: { id: another_user.id } },
            headers: { Authorization: user.token }

        expect(json_body['errors']).to include('resource' => ['is forbidden'])
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { FactoryBot.create(:user) }

    it 'returns 204 No Content' do
      delete "/api/users/#{user.id}", headers: { Authorization: user.token }

      expect(response).to have_http_status(:no_content)
    end

    it 'decrements users count by one' do
      user
      expect do
        delete "/api/users/#{user.id}", headers: { Authorization: user.token }
      end.to change(User, :count).by(-1)
    end

    context 'when unauthenticated' do
      it 'fails' do
        delete "/api/users/#{user.id}", headers: { Authorization: '' }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'responds with errors' do
        delete "/api/users/#{user.id}", headers: { Authorization: '' }
        expect(json_body['errors']).to include('token' => ['is invalid'])
      end
    end

    context 'when authenticated but unauthorized' do
      let(:another_user) { FactoryBot.create(:user) }

      before { another_user }

      it 'fails' do
        delete "/api/users/#{another_user.id}",
               headers: { Authorization: user.token }

        expect(response).to have_http_status(:forbidden)
      end

      it 'responds with errors' do
        delete "/api/users/#{another_user.id}",
               headers: { Authorization: user.token }

        expect(json_body['errors']).to include('resource' => ['is forbidden'])
      end
    end
  end
end
