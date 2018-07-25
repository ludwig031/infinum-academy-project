RSpec.describe 'Session API', type: :request do
  include TestHelpers::JsonResponse

  describe 'POST #create' do
    let(:user) { FactoryBot.create(:user) }

    before { user }

    context 'when params are valid' do
      it 'returns 201' do
        user = FactoryBot.create(:user)
        post '/api/session', params:
                               { session: { email: user.email,
                                            password: 'defaultPassword' } }

        expect(response).to have_http_status(:created)
      end

      it 'responds with token information' do
        user = FactoryBot.create(:user)
        post '/api/session', params:
                               { session: { email: user.email,
                                            password: 'defaultPassword' } }

        expect(json_body).to include('session' =>
                               include('token' => user.token))
      end

      it 'responds with user information' do
        user = FactoryBot.create(:user)
        post '/api/session', params:
            { session: { email: user.email,
                         password: 'defaultPassword' } }

        expect(json_body).to include('session' =>
                               include('user' =>
                                 include('id' => user.id)))
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        user = FactoryBot.create(:user)
        post '/api/session', params:
            { session: { email: user.email,
                         password: 'wrongPassword' } }

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns all errors' do
        user = FactoryBot.create(:user)
        post '/api/session', params:
            { session: { email: user.email,
                         password: 'wrongPassword' } }

        expect(json_body).to include('errors' =>
                               include('credentials' => ['are invalid']))
      end
    end
  end
end
