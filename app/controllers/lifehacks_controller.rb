class LifehacksController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def index
    @lifehacks = Lifehack.order(created_at: :desc)
  end

  def show
    @lifehack = Lifehack.find(params[:id])
    @reviews = @lifehack.reviews
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
    if params[:search].nil?
      @lifehacks = []
    else
      @lifehacks = Lifehack.where("title ILIKE ?", "%#{params[:search]}%")
    end
  end

  def destroy
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
      redirect_to @lifehack, notice: 'Lifehack Edited Successfully!'
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
    unless current_user == user
      flash[:alert] = "You are not the Authorized User"
      redirect_to after_sign_in_path_for(current_user)
    end
  end
end
