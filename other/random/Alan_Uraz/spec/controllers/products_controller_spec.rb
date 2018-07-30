require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  let(:quinn) do
    User.create!(username: 'quinn_leong', password: 'abcdef')
  end

  before(:each) do
    allow_message_expectations_on_nil
  end

  describe 'GET #new' do
    context 'when logged in' do
      before do
        allow(controller).to receive(:current_user) { quinn }
      end

      it 'renders the new products page' do
        get :new
        expect(response).to render_template(:new)
      end
    end

    context 'when logged out' do
      before do
        allow(controller).to receive(:current_user) { nil }
      end

      it 'redirects to the login page' do
        get :new
        expect(response).to redirect_to(new_session_url)
      end
    end
  end

  describe 'POST #create' do
    before do
      allow(controller).to receive(:current_user) { quinn }
    end

    context 'when logged in' do
      context 'with invalid params' do
        it 'validates the presence of title' do
          post :create, params: { product: { price: 129.99 } }
          expect(response).to render_template(:new)
          expect(flash[:errors]).to be_present
        end

        it 'validates the presence of price' do
          post :create, params: {
            product: {
              title: 'this is an invalid product'
            }
          }
          
          expect(response).to render_template(:new)
          expect(flash[:errors]).to be_present
        end
      end

      context 'with valid params' do
        it 'redirects to the product\'s show page' do
          post :create, params: {
            product: {
              title: 'Gage\'s Goggles',
              price: 14.99,
              description: 'These are cool.'
            }
          }

          expect(response).to redirect_to(product_url(Product.last))
        end
      end
    end

    context 'when logged out' do
      before do
        allow(controller).to receive(:current_user) { nil }
      end

      it 'redirects to the login page' do
        post :create, params: {
          product: {
            title: 'Here\'s a product',
            description: 'Buy it.'
          }
        }

        expect(response).to redirect_to(new_session_url)
      end
    end
  end

  describe 'GET #index' do
    context 'when logged in' do
      before do
        allow(controller).to receive(:current_user) { quinn }
      end

      it 'renders the products index' do
        get :index
        expect(response).to render_template('index')
      end
    end

    context 'when logged out' do
      before do
        allow(controller).to receive(:current_user) { nil }
      end

      it 'redirects to the login page' do
        get :index
        expect(response).to redirect_to(new_session_url)
      end
    end
  end

  describe 'GET #show' do
    create_jenn_with_product

    context 'when logged in as the product\'s owner' do
      before do
        allow(controller).to receive(:current_user) { jenn }
      end

      it 'renders the show page' do
        get :show, params: { id: jenn_product.id }
        expect(response).to render_template(:show)
      end
    end
  end

  describe 'GET #edit' do
    create_jenn_with_product

    context 'when logged in as the product\'s owner' do
      before do
        allow(controller).to receive(:current_user) { jenn }
      end

      it 'renders the edit page' do
        get :edit, params: { id: jenn_product.id }
        expect(response).to render_template(:edit)
      end
    end

    context 'when logged in as a different user' do
      before do
        allow(controller).to receive(:current_user) { quinn }
      end

      it 'does not render the edit page' do
        begin
          get :edit, params: { id: jenn_product.id }
        rescue ActiveRecord::RecordNotFound
        end

        expect(response).not_to render_template(:edit)
      end
    end
  end

  describe 'PATCH #update' do
    create_jenn_with_product

    context 'when logged in as the product\'s owner' do
      before do
        allow(controller).to receive(:current_user) { jenn }
      end

      it 'allows users to update their products' do
        patch :update, params: {
          id: jenn_product.id,
          product: {
            title: 'Jenn\'s Jeans'
          }
        }

        updated_product = Product.find(jenn_product.id)
        expect(updated_product.title).to eq('Jenn\'s Jeans')
      end
    end

    context 'when logged in as a different user' do
      before do
        allow(controller).to receive(:current_user) { quinn }
      end

      it 'does not allow users to update another user\'s products' do
        begin
          patch :update, params: {
            id: jenn_product.id,
            product: {
              title: 'Quinn Stuff'
            }
          }
        rescue ActiveRecord::RecordNotFound
        end

        updated_product = Product.find(jenn_product.id)
        expect(updated_product.title).to eq('Jenn\'s Jeans')
      end
    end
  end
end
