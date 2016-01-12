class Api::V1::ReviewsController < Api::V1::BaseController
  def show
    review = Review.find(params[:id])

    render(json: Api::V1::ReviewSerializer.new(review).to_json)
  end
end
