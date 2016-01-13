class ReviewsController < ApplicationController
  def index
    @reviews = Review.all
  end

  def new
    @lifehack = Lifehack.find(params[:lifehack_id])
    @review = Review.new
    @rating_list = Review::RATING_LIST
  end

  def create
    @lifehack = Lifehack.find(params[:lifehack_id])
    @review = Review.new(review_params)
    @user = current_user
    @review.lifehack = @lifehack
    @review.creator = @user
    if @review.save
      ReviewMailer.new_review(@review).deliver_later
      redirect_to lifehack_path(@lifehack), notice: 'Review made!'
    else
      @rating_list = Review::RATING_LIST
      flash.now[:error] = "Review rating can't be blank!"
      render :new
    end
  end

  def edit
    @review = Review.find(params[:id])
  end

  def destroy
    @lifehack = Lifehack.find(params[:lifehack_id])
    @review = Review.destroy(params[:id])
    redirect_to lifehack_path(@lifehack),
      notice: "Admin deleted review: #{@review.id}"
  end

  private

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end
