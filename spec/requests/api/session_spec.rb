RSpec.describe 'Companies API', type: :request do
  include TestHelpers::JsonResponse

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

        expect(json_body)
          .to include('errors' => include('credentials' => ['are invalid']))
      end
    end
  end
end
