class Api::V1::VotesController < Api::V1::BaseController
  def create
    review = Review.find(params[:review_id])
    vote = Vote.new
    vote.user = current_user
    vote.review = review
    vote.score = params[:score]
    if vote.save
      render(json: Api::V1::ReviewSerializer.new(review).to_json)
    end
  end
end
