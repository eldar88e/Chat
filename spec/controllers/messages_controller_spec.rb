require 'rails_helper'

describe MessagesController, type: :controller do
  let!(:user) { User.create(name: 'Test', email: 'test@example.com', password: '123456') }
  let!(:room) { Room.create(name: 'Test room').memberships.create(user_id: user.id).room }
  let!(:user2) { User.create(name: 'Test2', email: 'test2@example.com', password: '123456') }
  let!(:room2) { Room.create(name: 'Test room2').memberships.create(user_id: user2.id).room }

  describe 'GET #index' do
    context 'when user is authenticated' do
      before do
        sign_in user
        user.messages.create(content: 'Hi there!', sender_id: user.id)
        user2.messages.create(content: 'Hello!', sender_id: user.id)
        room.messages.create(content: 'Hello room!', sender_id: user.id)
        get :index, params: { user_id: user2.id }
      end

      it 'assigns all messages user2 to @messages' do
        get :index, params: { user_id: user2.id }
        expect(controller.instance_variable_get(:@messages)).to eq(user2.messages)
      end

      it 'assigns messages of user not exist messages of user2 to @messages' do
        get :index, params: { user_id: user2.id }
        expect(controller.instance_variable_get(:@messages)).not_to eq(user.messages)
      end

      it 'assigns all messages user to @messages' do
        get :index, params: { user_id: user.id }
        expect(controller.instance_variable_get(:@messages)).to eq(user.messages)
      end

      it 'assigns all messages not exist room to @messages' do
        get :index, params: { user_id: 999_999_999 }
        expect(response).to redirect_to(root_path)
      end

      it 'assigns all messages room to @messages' do
        get :index, params: { room_id: room.id }
        expect(controller.instance_variable_get(:@messages)).to eq(room.messages)
      end

      it 'assigns all messages not attached or not exist room to @messages' do
        get :index, params: { room_id: room2.id }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user is not authenticated' do
      context 'get messages for the user' do
        it 'returns a redirect status' do
          get :index, params: { user_id: user.id }
          expect(response).to have_http_status(302)
        end

        it 'redirects to the sign-in page with user' do
          get :index, params: { user_id: user.id }
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context 'get messages for the room' do
        it 'returns a redirect status' do
          get :index, params: { room_id: room.id }
          expect(response).to have_http_status(302)
        end

        it 'redirects to the sign-in page' do
          get :index, params: { room_id: room.id }
          expect(response).to redirect_to(new_user_session_path)
        end
      end
    end

    describe 'POST #create' do
      context 'when user is authenticated' do
        before { sign_in user }

        context 'when creating a message for a room' do
          it 'creates a new message for the room' do
            post :create, params: { room_id: room.id, message: { content: 'Hello room!' } }
            expect(response).to have_http_status(:ok)
            expect(room.messages.last.content).to eq('Hello room!')
            expect(room.messages.last.sender).to eq(user)
          end
        end

        context 'when creating a message for a user' do
          it 'creates a new message for the user' do
            post :create, params: { user_id: user2.id, message: { content: 'Hello user!' } }
            expect(response).to have_http_status(:ok)
            expect(user2.messages.last.content).to eq('Hello user!')
            expect(user2.messages.last.sender).to eq(user)
          end
        end
      end

      context 'when user is not authenticated' do
        context 'creates a new message for the user' do
          it 'redirects to the sign-in page' do
            post :create, params: { user_id: user2.id, message: { content: 'Hello user!' } }
            expect(response).to redirect_to(new_user_session_path)
          end

          it 'returns a redirect status' do
            post :create, params: { user_id: user2.id, message: { content: 'Hello user!' } }
            expect(response).to have_http_status(302)
          end
        end

        context 'creates a new message for the room' do
          it 'redirects to the sign-in page' do
            post :create, params: { room_id: room.id, message: { content: 'Hello the room!' } }
            expect(response).to redirect_to(new_user_session_path)
          end

          it 'returns a redirect status' do
            post :create, params: { room_id: room.id, message: { content: 'Hello the room!' } }
            expect(response).to have_http_status(302)
          end
        end
      end
    end
  end
end
