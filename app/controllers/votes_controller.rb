class VotesController < ApplicationController
  def create
    @review = Review.find(params[:review_id])
    @vote = Vote.new(vote_params)
    @vote.user = current_user
    if @vote.save
      redirect_to lifehack_path(@review.lifehack), notice: 'Vote cast!'
    end
  end

  def update
    @vote = Vote.find(params[:id])
    @review = Review.find(params[:review_id])
    if @vote.score == params["vote"]["score"].to_i
      if @vote.score == 1
        flash[:error] = "You have already upvoted this review!"
      elsif @vote.score == -1
        flash[:error] = "You have already downvoted this review!"
      end
      redirect_to lifehack_path(@review.lifehack)
    else
      @vote.update(vote_params)
      redirect_to lifehack_path(@review.lifehack), notice: "Vote updated!"
    end
  end

  private

  def vote_params
    params.require(:vote).permit(:score, :review_id)
  end
end
