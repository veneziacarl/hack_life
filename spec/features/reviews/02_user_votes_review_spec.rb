require 'rails_helper'

feature 'user adds vote', %{
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

  let (:samelifehack) { FactoryGirl.create(:lifehack) }
  let (:review) { FactoryGirl.create(:review, lifehack: samelifehack) }
  let (:review2) { FactoryGirl.create(:review, lifehack: samelifehack) }
  let (:review3) { FactoryGirl.create(:review) }
  let (:user) { FactoryGirl.create(:user) }
  let (:user2) { FactoryGirl.create(:user) }

  scenario 'user upvotes review' do
    user_sign_in(user)
    visit lifehack_path(review.lifehack)
    within('.review') do
      expect(page).to have_content("Score: 0")
    end
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
      expect(page).to have_content("Score: -1")
    end
  end

  scenario 'logged out user cannot vote review' do
    visit lifehack_path(review.lifehack)

    expect(page).to_not have_css('.vote_buttons')
  end

  scenario 'user can only make 1 up vote on a single review' do
    user_sign_in(user)
    visit lifehack_path(review.lifehack)
    click_button '+1'

    click_button '+1'

    expect(page).to have_content('You have already upvoted this review!')
    within('.review') do
      expect(page).to have_content("Score: 1")
    end
  end

  scenario 'user can only make 1 down vote on a single review' do
    user_sign_in(user)
    visit lifehack_path(review.lifehack)
    click_button '-1'

    click_button '-1'

    expect(page).to have_content('You have already downvoted this review!')
    within('.review') do
      expect(page).to have_content("Score: -1")
    end
  end

  scenario 'user can change vote on already voted review' do
    user_sign_in(user)
    visit lifehack_path(review.lifehack)
    click_button '+1'

    expect(page).to have_content('Vote cast!')
    click_button '-1'

    expect(page).to have_content('Vote updated!')
    within('.review') do
      expect(page).to have_content("Score: -1")
    end
  end

  scenario 'user can vote for multiple reviews on the same lifehack' do
    review2
    user_sign_in(user)
    visit lifehack_path(review.lifehack)
    within(".review-#{review.id}") do
      click_button '+1'
    end

    expect(page).to have_content('Vote cast!')
    within(".review-#{review.id}") do
      expect(page).to have_content("Score: 1")
    end

    within(".review-#{review2.id}") do
      click_button '+1'
    end

    expect(page).to have_content('Vote cast!')
    within(".review-#{review.id}") do
      expect(page).to have_content("Score: 1")
    end
    within(".review-#{review2.id}") do
      expect(page).to have_content("Score: 1")
    end
  end

  scenario 'dry out code for last test'
end
