require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  create_jenn_with_product

  let(:shamayel) do
    User.create!(username: 'shamayel_daoud', password: 'abcdef')
  end

  let(:shamayel_product) do
    Product.create!(
      title: 'Cool Boots',
      price: 300.00,
      description: 'These sure look cool.',
      user: shamayel
    )
  end

  before(:each) do
    allow_message_expectations_on_nil
  end

  describe 'POST #create' do
    before do
      allow(controller).to receive(:current_user) { shamayel }
    end

    # NOTE: for post requests, the link_id should be sent in the url, like so:
    # '/products/:product_id/comments'
    it { should route(:post, '/products/1/comments').to(action: :create, product_id: 1) }

    context 'when logged in' do
      context 'with invalid params' do
        it 'does not create the comment and redirects to the product show page' do
          post :create, params: {
            product_id: shamayel_product.id,
            comment: {
              body: nil
            }
          }

          expect(response).to redirect_to(product_url(shamayel_product))
          expect(Comment.exists?(body: 'vacuum')).to be false
        end
      end

      context 'with valid params' do
        it 'creates the comment and redirects to the product show page' do
          post :create, params: {
            product_id: shamayel_product.id,
            comment: {
              body: 'vacuum'
            }
          }

          expect(response).to redirect_to(product_url(shamayel_product))
          expect(Comment.exists?(body: 'vacuum')).to be true
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:first_comment) do
      Comment.create!({
        product: shamayel_product,
        author: jenn,
        body: 'eat potatoes'
      })
    end

    context 'when logged in as the comment\'s owner' do
      before do
        allow(controller).to receive(:current_user) { jenn }
      end

      it 'removes the comment and redirects back to the product show' do
        delete :destroy, params: { id: first_comment.id }

        expect(response).to redirect_to(product_url(shamayel_product))
        expect(Comment.exists?(first_comment.id)).to be false
      end
    end

    context 'when logged in as a different user' do
      before do
        allow(controller).to receive(:current_user) { shamayel }
      end

      it 'does not delete the comment' do
        begin
          delete :destroy, params: { id: first_comment.id }
        rescue ActiveRecord::RecordNotFound
        end

        expect(Comment.exists?(id: first_comment.id)).to be true
      end
    end
  end
end
