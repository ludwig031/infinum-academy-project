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
    let(:user) { FactoryBot.create(:user) }
    let(:user_params) do
      { 'email' => user.email, 'password' => user.password }
    end

    let(:wrong_params) do
      { 'email' => 'mail@email.com', 'password' => 'wrongPass' }
    end

    before { user }

    context 'when params are valid' do
      it 'returns 201' do
        post '/api/session', params:
            { 'session' => user_params }

        expect(response).to have_http_status(:created)
      end

      it 'responds with token information' do
        post '/api/session', params:
            { 'session' => user_params }

        expect(json_body).to include('session' =>
                                         include('token' => user.token))
      end

      it 'responds with user information' do
        post '/api/session', params:
            { 'session' => user_params }

        expect(json_body).to include('session' =>
                                         include('user' =>
                                                     include('id' => user.id)))
      end

      it 'can authenticate with provided password' do
        post '/api/session', params:
            { 'session' => user_params }

        id = json_body['session']['user']['id']
        auth_user = User.find_by(id: json_body['session']['user']['id'])
                        .try(:authenticate, 'defaultPassword')

        expect(id).to eq(auth_user.id)
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        post '/api/session', params:
            { 'session' => wrong_params }

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns all errors' do
        post '/api/session', params:
            { 'session' => wrong_params }

        expect(json_body).to include('errors' =>
                               include('credentials' => ['are invalid']))
      end
    end
  end

  describe 'PATCH #update' do
    let(:user) { FactoryBot.create(:user) }

    context 'when params are valid password is changed' do
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
