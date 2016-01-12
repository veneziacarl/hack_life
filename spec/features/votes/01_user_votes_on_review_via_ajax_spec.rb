require 'rails_helper'

feature "user adds vote to review via ajax", %{
  As a User
  I want to vote on a review
  Without having the page refresh
} do

  # Acceptance Criteria:
  # [] When I click on the vote button page should not refresh
  # [] When I vote on a review the score should be update immmidiately
  # []  When I click the note button twice, the vote should only update once
  # []  When I click the note button twice, an error message should display

  let (:user) { FactoryGirl.create(:user) }
  let (:user2) { FactoryGirl.create(:user) }
  let (:samelh) { FactoryGirl.create(:lifehack) }
  let (:review) { FactoryGirl.create(:review) }
  let (:review_list) { FactoryGirl.create_list(:review, 2, lifehack: samelh) }
  let (:review_different_lifehack) { FactoryGirl.create_list(:review, 2) }

  scenario 'user upvotes review', js: true do
    user_sign_in(user)
    visit lifehack_path(review.lifehack)

    click_button '+1'

    expect(page).to have_content("Score: 1")
    expect(page).to_not have_content("Vote cast!")
  end

  scenario 'user downvotes review', js: true do
    user_sign_in(user)
    visit lifehack_path(review.lifehack)

    click_button '-1'

    expect(page).to have_content("Score: -1")
    expect(page).to_not have_content("Vote cast!")
  end

  scenario 'user can only make 1 up vote on a single review', js: true do
    FactoryGirl.create(:vote, user: user, review: review)
    user_sign_in(user)
    visit lifehack_path(review.lifehack)

    click_button '+1'

    expect(page).to have_content('You have already upvoted this review!')
    expect(page).to have_content("Score: 1")
  end

  scenario 'user can only make 1 down vote on a single review', js: true do
    FactoryGirl.create(:vote, :down, user: user, review: review)
    user_sign_in(user)
    visit lifehack_path(review.lifehack)

    click_button '-1'

    expect(page).to have_content('You have already downvoted this review!')
    expect(page).to have_content("Score: -1")
  end

  scenario 'user can change vote on already voted review', js: true do
    FactoryGirl.create(:vote, user: user, review: review)
    user_sign_in(user)
    visit lifehack_path(review.lifehack)

    click_button '-1'

    expect(page).to have_content("Score: -1")
  end
end
