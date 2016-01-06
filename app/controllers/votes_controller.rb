class VotesController < ApplicationController
  def create
    @review = Review.find(params[:review_id])
    @vote = Vote.new(vote_params)
    @vote.user = current_user
    if @vote.save
      redirect_to lifehack_path(@review.lifehack), notice: 'Vote cast!'
    else
      flash.now[:error] = "Could not cast vote."
    end
  end

  private

  def vote_params
    params.require(:vote).permit(:score, :review_id)
  end
end
