class ReviewsController < ApplicationController
  def index
    @reviews = Review.all
  end

  def new
    # @lifehack
    @review = Review.new
    @rating_list = Review::RATING_LIST
  end

  def create
    @review = Review.new(review_params)

    if @review.save
      redirect_to reviews_path, notice: 'Review made!'
    else
      @rating_list = Review::RATING_LIST
      flash.now[:error] = "Review rating can't be blank!"
      render :new
    end
  end

  private
  
  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end
