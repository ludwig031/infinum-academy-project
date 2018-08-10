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
            { session: user_params }

        expect(response).to have_http_status(:created)
      end

      it 'responds with token information' do
        post '/api/session', params:
            { session: user_params }

        expect(json_body['session']).to include('token' => user.token)
      end

      it 'responds with user information' do
        post '/api/session', params:
            { session: user_params }

        expect(json_body['session'])
          .to include('user' => include('id' => user.id))
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        post '/api/session', params:
            { session: wrong_params }

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns all errors' do
        post '/api/session', params:
            { session: wrong_params }

        expect(json_body['errors']).to include('credentials' => ['are invalid'])
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { FactoryBot.create(:user, token: 'los:token') }

    before { user }

    context 'when succeeds' do
      it 'returns 204 No Content' do
        delete '/api/session', headers: { Authorization: user.token }

        expect(response).to have_http_status(:no_content)
      end

      it 'changes user token' do
        expect do
          delete '/api/session', headers: { Authorization: user.token }
        end.to(change { user.reload.token })
      end
    end

    context 'when fails' do
      it 'returns 401 Unauthorized' do
        delete '/api/session', headers: { Authorization: '' }

        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns all errors' do
        delete '/api/session', headers: { Authorization: '' }

        expect(json_body).to include('errors')
      end
    end
  end
end
