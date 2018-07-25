RSpec.describe 'Users API', type: :request do
  include TestHelpers::JsonResponse

  describe 'GET #index' do
    let(:users) { FactoryBot.create_list(:user, 3) }

    before { users }

    it 'returns http success' do
      get '/api/users'
      expect(response).to have_http_status(:success)
    end

    it 'returns list of users' do
      get '/api/users'
      expect(json_body['users'].length).to eq 3
    end
  end

  describe 'GET #show' do
    let(:user) { FactoryBot.create(:user) }

    it 'returns http success' do
      get "/api/users/#{user.id}"
      expect(response).to have_http_status(:success)
    end

    it 'returns a single user' do
      get "/api/users/#{user.id}"
      expect(json_body).to include('user')
    end
  end

  describe 'POST #create' do
    context 'when params are valid' do
      it 'returns 201' do
        post '/api/users',
             params: { user: { first_name: 'Ljudevit',
                               last_name: 'Ludwig',
                               email: 'mail-1@mail.com',
                               password: 'password' } }

        expect(response).to have_http_status(:created)
      end

      it 'changes users count by one' do
        expect do
          post '/api/users',
               params: { user: { first_name: 'Ljudevit',
                                 last_name: 'Ludwig',
                                 email: 'mail-2@mail.com',
                                 password: 'password' } }
        end.to change(User, :count).by(+1)
      end

      it 'creates and returns a new user' do
        post '/api/users',
             params: { user: { first_name: 'Ljudevit',
                               last_name: 'Ludwig',
                               email: 'mail-3@mail.com',
                               password: 'password' } }

        expect(json_body).to include('user' => include('last_name' => 'Ludwig'))
      end

      it 'can authenticate' do
        post '/api/users',
             params: { user: { first_name: 'Ljudevit',
                               last_name: 'Ludwig',
                               email: 'mail-3@mail.com',
                               password: 'password' } }

        user = User.find_by(id: json_body['user']['id'])
        auth_user = user.try(:authenticate, 'password')
        expect(user).to eq(auth_user)
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

    context 'when params are valid' do
      it 'returns 200 OK' do
        put "/api/users/#{user.id}",
            params: { user: { first_name: 'Ime' } }

        expect(response).to have_http_status(:success)
      end

      it 'returns a updated user' do
        put "/api/users/#{user.id}",
            params: { user: { first_name: 'Ime' } }

        expect(json_body).to include('user' => include('first_name' => 'Ime'))
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        put "/api/users/#{user.id}",
            params: { user: { first_name: '' } }

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns all errors' do
        put "/api/users/#{user.id}",
            params: { user: { first_name: '' } }

        expect(json_body).to include('errors')
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { FactoryBot.create(:user) }

    it 'returns 204 No Content' do
      delete "/api/users/#{user.id}"

      expect(response).to have_http_status(:no_content)
    end

    it 'decrements users count by one' do
      user
      expect do
        delete "/api/users/#{user.id}"
      end.to change(User, :count).by(-1)
    end
  end
end
