class ProductsController < ApplicationController
  
  before_action :require_log_in
  
  def new
    @product = Product.new
  end
  
  def create
    @product = Product.new(product_params)
    @product.user_id = current_user.id
    if @product.save 
      redirect_to product_url(@product)
    else 
      flash[:errors] = @product.errors.full_messages
      render :new
    end
  end
  
  def index
    @products = Product.all
  end
  
  def show
    @product = Product.find(params[:id])
  end
  
  def edit
    @product = Product.find(params[:id])
    # debugger
    unless @product.user_id == current_user.id
      redirect_to new_product_url
    end
  end
  
  def update 
    @product = Product.find(params[:id])
    unless @product.user_id == current_user.id 
      redirect_to products_url 
    else 
      if @product.update(product_params)
        redirect_to product_url(@product)
      else 
        flash[:errors] = @product.errors.full_messages
        render :edit
      end
    end
    
  end
  
  def product_params
    params.require(:product).permit(:title, :description, :price)
  end
  
  # def require_to_edit
  #   redirect_to new_product_url unle
  # end
  
end