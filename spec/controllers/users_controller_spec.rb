RSpec.describe UsersController, type: :controller do
  describe 'GET #index' do
    let(:users) { FactoryBot.create_list(:user) }

    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'returns list of users' do
      get :index
      expect(response).to be_success
    end
  end

  describe 'GET #show' do
    let(:user) { FactoryBot.create(:user) }

    it 'returns http success' do
      get :show, params: { id: user.id }
      expect(response).to have_http_status(:success)
    end

    it 'returns a single user' do
      get :show, params: { id: user.id }
      json_body = JSON.parse(response.body)
      expect(json_body).to include('user')
    end
  end

  describe 'POST #create' do
    context 'when params are valid' do
      it 'returns 201' do
        post :create, params: { user: { first_name: 'Ljudevit',
                                        last_name: 'Ludwig',
                                        email: 'mail-1@mail.com' } }

        expect(response).to have_http_status(:created)
      end

      it 'creates and returns a new user' do
        post :create, params: { user: { first_name: 'Ljudevit',
                                        last_name: 'Ludwig',
                                        email: 'mail-2@mail.com' } }

        json_body = JSON.parse(response.body)
        expect(json_body).to include('user' => include('last_name' => 'Ludwig'))
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        post :create, params: { user: { first_name: '' } }

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns all errors' do
        post :create, params: { user: { nafirst_nameme: '' } }

        json_body = JSON.parse(response.body)
        expect(json_body).to include('errors')
      end
    end
  end

  describe 'PATCH #update' do
    let(:user) { FactoryBot.create(:user) }

    context 'when params are valid' do
      it 'returns 200 OK' do
        post :update, params: { id: user.id,
                                user: { first_name: 'Ime' } }

        expect(response).to have_http_status(:success)
      end

      it 'returns a created booking' do
        post :update, params: { id: user.id,
                                user: { first_name: 'Ime' } }

        json_body = JSON.parse(response.body)
        expect(json_body).to include('user' => include('first_name' => 'Ime'))
      end
    end

    context 'when params are invalid' do
      it 'returns 400 Bad Request' do
        post :update, params: { id: user.id,
                                user: { first_name: '' } }

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns all errors' do
        post :update, params: { id: user.id,
                                user: { first_name: '' } }

        json_body = JSON.parse(response.body)
        expect(json_body).to include('errors')
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { FactoryBot.create(:user) }

    it 'returns 204 No Content' do
      post :destroy, params: { id: user.id }

      expect(response).to have_http_status(:no_content)
    end
  end
end
