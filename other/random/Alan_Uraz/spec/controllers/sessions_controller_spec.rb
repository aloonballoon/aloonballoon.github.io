require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let!(:user) do
    User.create({ username: 'debra_fong', password: 'abcdef' })
  end

  describe 'GET #new' do
    it 'renders the new session template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with invalid credentials' do
      it 'returns to sign in with an non-existent user' do
        post :create, params: {
          user: {
            username: 'shamayel_daoud',
            password: 'abcdef'
          }
        }

        expect(response).to render_template(:new)
        expect(flash[:errors]).to be_present
      end

      it 'returns to sign in on bad password' do
        post :create, params: {
          user: {
            username: 'debra_fong',
            password: 'notmypassword'
          }
        }

        expect(response).to render_template(:new)
        expect(flash[:errors]).to be_present
      end
    end

    context 'with valid credentials' do
      it 'redirects user to products index on success' do
        post :create, params: {
          user: {
            username: 'debra_fong',
            password: 'abcdef'
          }
        }

        expect(response).to redirect_to(products_url)
      end

      it 'logs in the user' do
        post :create, params: {
          user: {
            username: 'debra_fong',
            password: 'abcdef'
          }
        }

        debra = User.find_by(username: 'debra_fong')
        expect(session[:session_token]).to eq(debra.session_token)
      end
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      post :create, params: {
        user: {
          username: 'debra_fong',
          password: 'abcdef'
        }
      }

      debra = User.find_by(username: 'debra_fong')
      @session_token = debra.session_token
    end

    it 'logs out the current user' do
      delete :destroy
      expect(session[:session_token]).to be_nil

      debra = User.find_by(username: 'debra_fong')
      expect(debra.session_token).not_to eq(@session_token)
    end
  end
end
