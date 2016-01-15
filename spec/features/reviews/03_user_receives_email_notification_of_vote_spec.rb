require 'rails_helper'

feature 'user gets email when someone votes on their review', %{
  As a User
  I want to get an email notification when someone votes on my review
  So I can see what community members think of my review
} do

  # Acceptance Criteria:
  # [x] I get an email when someone votes on my review.

  let (:samelh) { FactoryGirl.create(:lifehack) }
  let (:review) { FactoryGirl.create(:review, lifehack: samelh) }
  let (:user) { FactoryGirl.create(:user) }

  scenario 'user recieves email notification of their upvoted review' do

    user_sign_in(user)
    visit lifehack_path(review.lifehack)
    within('.review') do
      expect(page).to have_content("Score")
      expect(page).to have_content("0")
    end
    click_button '+1'

    expect(page).to have_content('Vote cast!')
    within('.review') do
      expect(page).to have_content("Score")
      expect(page).to have_content("1")
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end
  end

  scenario 'user receives email notification of their downvoted review' do

    user_sign_in(user)
    visit lifehack_path(review.lifehack)
    click_button '-1'

    expect(page).to have_content('Vote cast!')
    within('.review') do
      expect(page).to have_content("Score")
      expect(page).to have_content("-1")
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end
  end
end
