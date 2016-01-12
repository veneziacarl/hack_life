class UsersController < ApplicationController
  def index
    @users = User.order(created_at: :desc)
  end

  def show
    @user = current_user
    @lifehacks = Lifehack.where(creator_id: params[:id])
    @reviews = Review.where(creator_id: params[:id])
  end
end
