require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #new' do
    it 'renders the new users template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with invalid params' do
      it 'validates the presence of the user\'s username and password' do
        post :create, params: {
          user: {
            username: 'shamayel_daoud',
            password: ''
          }
        }

        expect(response).to render_template(:new)
        expect(flash[:errors]).to be_present
      end

      it 'validates that the password is at least 6 characters long' do
        post :create, params: {
          user: {
            username: 'shamayel_daoud',
            password: 'short'
          }
        }

        expect(response).to render_template(:new)
        expect(flash[:errors]).to be_present
      end
    end

    context 'with valid params' do
      it 'redirects user to products index on success' do
        post :create, params: {
          user: {
            username: 'shamayel_daoud',
            password: 'password'
          }
        }
        expect(response).to redirect_to(products_url)
      end

      it 'logs in the user' do
        post :create, params: {
          user: {
            username: 'shamayel_daoud',
            password: 'abcdef'
          }
        }

        user = User.find_by_username('shamayel_daoud')
        expect(session[:session_token]).to eq(user.session_token)
      end
    end
  end
end
