class LifehacksController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def index
    @lifehacks = Lifehack.order(created_at: :desc).page(params[:page])
  end

  def show
    @lifehack = Lifehack.find(params[:id])
    @reviews = @lifehack.reviews.order(created_at: :desc).page(params[:page])
    @reviews = @reviews.sort_by { |review| review.sum_score }.reverse
  end

  def new
    if user_signed_in?
      @lifehack = Lifehack.new
    else
      flash[:error] = "You must be signed in to add a lifehack!"
      redirect_to lifehacks_path
    end
  end

  def create
    @lifehack = Lifehack.new(lifehack_params)
    @user = current_user
    @lifehack.creator = @user
    if @lifehack.save
      redirect_to lifehack_path(@lifehack),
        notice: 'Lifehack Created Successfully!'
    else
      flash.now[:error] = "error in submission"
      render :new
    end
  end

  def search
    @lifehacks = []
    if search_params[:all] && search_params[:all] != ""
      @lifehacks << Lifehack.search_all(search_params[:all])
    end
    if search_params[:title] && search_params[:title] != ""
      @lifehacks << Lifehack.search_title(search_params[:title])
    end
    if search_params[:description] && search_params[:description] != ""
      @lifehacks << Lifehack.search_description(search_params[:description])
    end
    if search_params[:user] && search_params[:user] != ""
      @lifehacks << Lifehack.search_user(search_params[:user])
    end
    @lifehacks = @lifehacks.flatten.uniq
  end

  def destroy
    @lifehack = Lifehack.find(params[:id])
    Review.delete(@lifehack.reviews)
    @lifehack = Lifehack.destroy(params[:id])
    redirect_to root_path,
      notice: "Admin successfully deleted lifehack: #{@lifehack.title}"
  end

  def edit
    @lifehack = Lifehack.find(params[:id])
  end

  def update
    @lifehack = Lifehack.find(params[:id])

    if @lifehack.update_attributes(lifehack_params)
      if current_user.admin?
        redirect_to @lifehack, notice:
          "Admin successfully edited lifehack: #{@lifehack.title}"
      else
        redirect_to @lifehack, notice: 'Lifehack Edited Successfully!'
      end
    else
      render :edit, notice: 'You are not the authorized user'
    end
  end

  private

  def lifehack_params
    params.require(:lifehack).permit(:title, :description)
  end

  def authorize_user!
    user = Lifehack.find(params[:id]).creator
    unless current_user == user || current_user.admin?
      flash[:alert] = "You are not the Authorized User"
      redirect_to after_sign_in_path_for(current_user)
    end
  end

  def search_params
    params.require(:search).permit(:title, :description, :user, :all)
  end
end
