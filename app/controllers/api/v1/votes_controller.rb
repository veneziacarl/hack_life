class Api::V1::VotesController < Api::V1::BaseController
  def create
    review = Review.find(params[:review_id])
    vote = Vote.new(vote_params)
    vote.user = current_user
    if vote.save
      render(json: { data: Api::V1::ReviewSerializer.new(review), vote: vote })
    end
  end

  def update
    vote = Vote.find(params[:id])
    review = Review.find(params[:review_id])
    if vote.score == vote_params["score"].to_i
      if vote.score == 1
        render json: { error: "You have already upvoted this review!" },
          status: 422
      elsif vote.score == -1
        render json: { error: "You have already downvoted this review!" },
          status: 422
      end
    else
      vote.update(vote_params)
      render(json: Api::V1::ReviewSerializer.new(review).to_json)
    end
  end

  private

  def vote_params
    params.permit(:score, :review_id)
  end
end
