require 'rails_helper'
require 'orderly'

feature "votes are ordered by sum_score", %{
  As a User
  I want to see the highest voted reviews at the top
  So that I can quickly see the best reviews
} do

  let! (:lifehack) { FactoryGirl.create(:lifehack) }
  let! (:user) { FactoryGirl.create(:user) }
  let! (:reviews) { FactoryGirl.create_list(:review, 3, lifehack: lifehack) }
  let! (:downvote) { FactoryGirl.create(:vote, :down, review: reviews[1]) }
  let! (:downvote2) do
    FactoryGirl.create_list(:vote, 2, :down, review: reviews[2])
  end
  let! (:upvote) { FactoryGirl.create(:vote, review: reviews[0]) }

  scenario 'reviews are initially sorted by upvotes' do
    user_sign_in(user)
    visit lifehack_path(lifehack)

    expect(reviews[0].comment).to appear_before(reviews[1].comment)
    expect(reviews[0].comment).to appear_before(reviews[2].comment)
    expect(reviews[1].comment).to appear_before(reviews[2].comment)
  end
end
