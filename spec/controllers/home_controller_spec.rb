require 'rails_helper'

describe HomeController, type: :controller do
  describe 'GET #index' do
    context 'when user is authenticated' do
      let(:user) { User.create(name: 'Test', email: 'test@example.com', password: '123456') }
      let!(:room) { Room.create(name: 'Test room').memberships.create(user_id: user.id) }
      let(:user2) { User.create(name: 'Test2', email: 'test2@example.com', password: '123456') }
      let!(:room2) { Room.create(name: 'Test room2').memberships.create(user_id: user2.id) }

      before do
        sign_in user
        get :index
      end

      it 'assigns all users to @users' do
        expect(controller.instance_variable_get(:@users)).to eq(User.all)
      end

      it 'assigns current user\'s rooms to @rooms' do
        expect(controller.instance_variable_get(:@rooms)).to eq(user.rooms)
      end

      it 'assigns current user\'s no included in rooms2' do
        expect(controller.instance_variable_get(:@rooms)).not_to include(user2.rooms)
      end

      it 'returns a successful response' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is not authenticated' do
      it 'returns a redirect status' do
        get :index
        expect(response).to have_http_status(302)
      end

      it 'redirects to the sign-in page' do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end