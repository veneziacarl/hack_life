class LifehacksController < ApplicationController
  def index
    @lifehacks = Lifehack.all.order(created_at: :desc)
  end

  def show
    @lifehack = Lifehack.find(params[:id])
    @reviews = @lifehack.reviews
  end
end
