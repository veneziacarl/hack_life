class LifehacksController < ApplicationController
  before_action :authenticate_user!, except: [:index]
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
    @lifehack = Lifehack.destroy(params[:id])
    redirect_to lifehacks_path,
      notice: "Admin successfully deleted lifehack: #{@lifehack.title}"
  end

  private

  def lifehack_params
    params.require(:lifehack).permit(:title, :description)
  end

  def search_params
    params.require(:search).permit(:title, :description, :user, :all)
  end
end
