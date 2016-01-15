require 'rails_helper'

feature 'user adds vote', %{
  As a User
  I want to vote on a review
  So I can interact with the community
} do

  # Acceptance Criteria:
  # [x] I can upvote an existing lifehack review and see the score change
  # [x] I can downvote an existing lifehack review and see the score change
  # [x] If `review 1` has a higher score than `review 2`, I should see that
  # review higher in the list
  # [x] If I am not logged in, I cannot vote on a review

  let (:samelh) { FactoryGirl.create(:lifehack) }
  let (:review) { FactoryGirl.create(:review) }
  let (:review_list) { FactoryGirl.create_list(:review, 2, lifehack: samelh) }
  let (:review_different_lifehack) { FactoryGirl.create_list(:review, 2) }
  let (:user) { FactoryGirl.create(:user) }
  let (:user2) { FactoryGirl.create(:user) }

  scenario 'user upvotes review' do
    user_sign_in(user)
    visit lifehack_path(review.lifehack)
    within('.review') do
      expect(page).to have_content("0")
    end
    click_button '+1'

    expect(page).to have_content('Vote cast!')
    within('.review') do
      expect(page).to have_content("1")
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
      expect(page).to have_content("2")
    end
  end

  scenario 'user downvotes review' do
    user_sign_in(user)
    visit lifehack_path(review.lifehack)
    click_button '-1'

    expect(page).to have_content('Vote cast!')
    within('.review') do
      expect(page).to have_content("-1")
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
      expect(page).to have_content("1")
    end
  end

  scenario 'user can only make 1 down vote on a single review' do
    user_sign_in(user)
    visit lifehack_path(review.lifehack)
    click_button '-1'

    click_button '-1'

    expect(page).to have_content('You have already downvoted this review!')
    within('.review') do
      expect(page).to have_content("-1")
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
      expect(page).to have_content("-1")
    end
  end

  scenario 'user can up vote for multiple reviews on the same lifehack' do
    user_sign_in(user)
    visit lifehack_path(review_list.first.lifehack)

    review_list.each do |review|
      within(".review-#{review.id}") do
        click_button '+1'
      end

      expect(page).to have_content('Vote cast!')
      within(".review-#{review.id}") do
        expect(page).to have_content("1")
      end
    end

    within(".review-#{review_list.first.id}") do
      expect(page).to have_content("1")
    end
  end

  scenario 'user can down vote for multiple reviews on the same lifehack' do
    user_sign_in(user)
    visit lifehack_path(review_list.first.lifehack)

    review_list.each do |review|
      within(".review-#{review.id}") do
        click_button '-1'
      end

      expect(page).to have_content('Vote cast!')
      within(".review-#{review.id}") do
        expect(page).to have_content("-1")
      end
    end

    within(".review-#{review_list.first.id}") do
      expect(page).to have_content("-1")
    end
  end

  scenario 'user cannot vote for same review after voting on another review' do
    user_sign_in(user)
    visit lifehack_path(review_list.first.lifehack)

    review_list.each do |review|
      within(".review-#{review.id}") do
        click_button '-1'
      end

      expect(page).to have_content('Vote cast!')
      within(".review-#{review.id}") do
        expect(page).to have_content("-1")
      end
    end

    within(".review-#{review_list.first.id}") do
      click_button '-1'

      expect(page).to have_content("-1")
    end
    expect(page).to have_content('You have already downvoted this review!')
  end

  scenario 'user can up vote for reviews on different lifehacks' do
    user_sign_in(user)

    review_different_lifehack.each do |review|
      visit lifehack_path(review.lifehack)

      within(".review-#{review.id}") do
        click_button '+1'
      end

      expect(page).to have_content('Vote cast!')
      within(".review-#{review.id}") do
        expect(page).to have_content("1")
      end
    end
  end
end
