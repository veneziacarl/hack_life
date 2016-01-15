class ReviewsController < ApplicationController
  def index
    @lifehack = Lifehack.find(params[:lifehack_id])
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
    @reviews = @lifehack.reviews.order(created_at: :desc).page(params[:page])
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
    @lifehack = Lifehack.find(params[:lifehack_id])
    @review = Review.find(params[:id])
    @rating_list = Review::RATING_LIST
  end

  def update
    @lifehack = Lifehack.find(params[:lifehack_id])
    @review = Review.find(params[:id])

    if @review.update_attributes(review_params)
      if current_user.admin?
        redirect_to @lifehack, notice: "Admin edited review: #{@review.id}"
      else
        redirect_to @lifehack, notice: 'Review edited successfully!'
      end
    else
      render :edit, notice: 'You are not the authorized user'
    end
  end

  def destroy
    @lifehack = Lifehack.find(params[:lifehack_id])
    @review = Review.destroy(params[:id])
    redirect_to lifehack_path(@lifehack),
      notice: "Admin deleted review: #{@review.id}"
  end

  private

  def review_params
    params.require(:review).permit(:rating, :comment, :creator_id, :lifehack_id)
  end
end
