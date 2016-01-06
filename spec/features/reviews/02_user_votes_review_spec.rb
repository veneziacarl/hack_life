require 'rails_helper'

feature 'user adds review', %{
  As a User
  I want to vote on a review
  So I can interact with the community
} do

  # Acceptance Criteria:
  # [ ] I can upvote an existing lifehack review and see the score change
  # [ ] I can downvote an existing lifehack review and see the score change
  # [ ] If `review 1` has a higher score than `review 2`, I should see that
  # review higher in the list
  # [x] If I am not logged in, I cannot vote on a review

  let (:review) { FactoryGirl.create(:review) }
  let (:user) { FactoryGirl.create(:user) }
  let (:user2) { FactoryGirl.create(:user) }

  scenario 'user upvotes review' do
    user_sign_in(user)
    visit lifehack_path(review.lifehack)
    click_button '+1'

    expect(page).to have_content('Vote cast!')
    within('.review') do
      expect(page).to have_content("Score: 1")
    end
  end

  scenario 'multiple users upvote the same review' do
    user_sign_in(user)
    visit lifehack_path(review.lifehack)
    click_button '+1'

    click_link 'Sign Out'

    user_sign_in(user2)
    visit lifehack_path(review.lifehack)
    click_button '+1'

    expect(page).to have_content('Vote cast!')
    within('.review') do
      expect(page).to have_content("Score: 2")
    end
  end

  scenario 'user downvotes review' do
    user_sign_in(user)
    visit lifehack_path(review.lifehack)
    click_button '-1'

    expect(page).to have_content('Vote cast!')
    within('.review') do
      expect(page).to have_content("Score: #{review.sum_score}")
    end
  end

  scenario 'logged out user cannot vote review' do
    visit lifehack_path(review.lifehack)

    expect(page).to_not have_css('.vote_buttons')
  end

  scenario 'user can only make 1 up or down vote on a single review'
  scenario 'user can change vote on already voted review'
  scenario 'user can vote for multiple reviews'
end
