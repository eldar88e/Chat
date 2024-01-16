require 'rails_helper'

RSpec.describe RoomsController, type: :controller do
  describe 'POST #create' do
    context 'when user is authenticated' do
      let(:user) { User.create(name: 'Test', email: 'test@example.com', password: '123456') }

      before { sign_in user }

      it 'creates a new room with a membership for the current user' do
        post :create, params: { name: 'Test Room' }

        expect(response).to have_http_status(:ok)
        expect(Room.count).to eq(1)
        expect(Membership.count).to eq(1)

        created_room       = Room.first
        created_membership = Membership.first

        expect(created_room.name).to eq('Test Room')
        expect(created_membership.user).to eq(user)
        expect(created_membership.room).to eq(created_room)
      end

      it 'redirects to root_path if room save fails' do
        allow_any_instance_of(Room).to receive(:save).and_return(false)

        post :create, params: { name: 'Test Room' }

        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to sign_in path' do
        post :create, params: { name: 'Test Room' }

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
