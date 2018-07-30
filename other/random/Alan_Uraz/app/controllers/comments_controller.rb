class CommentsController < ApplicationController 
  
  before_action :require_log_in
  
  def new
    @comment = Comment.new
  end
  
  def create
    # debugger
    @comment =Comment.new(comment_params)
    @comment.user_id = current_user.id 
    @comment.product_id = params[:product_id]
    @comment.save 
    flash[:errors] = @comment.errors.full_messages
    redirect_to product_url(@comment.product_id)
  end
  
  def destroy
    # debugger
    @comment = Comment.find(params[:id])
    unless current_user.id == @comment.user_id
      redirect_to product_url(@comment.product_id)
    else 
      @comment.destroy
      redirect_to product_url(@comment.product_id)
    end
  end
  
  def comment_params
    params.require(:comment).permit(:body)
  end
  
end