class LifehacksController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  def index
    @lifehacks = Lifehack.order(created_at: :desc).page(params[:page])
  end

  def show
    @lifehack = Lifehack.find(params[:id])
    @review = Review.new
    @reviews = @lifehack.reviews.order(created_at: :desc).page(params[:page])
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
    redirect_to lifehacks_path,
      notice: "Admin successfully deleted lifehack: #{@lifehack.title}"
  end

  private

  def lifehack_params
    params.require(:lifehack).permit(:title, :description)
  end
end
