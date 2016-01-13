require 'rails_helper'

feature 'user views reviews for a lifehack', %{
    'As a user
    I want to view all reviews on a lifehack
    So that I can decide which lifehack I might want to use'
  } do

  # Acceptance criteria
  # [√] I must be logged in
  # [√] I must be on the lifehack details page
  # [√] I can see a list of reviews ordered by most recent review

  let!(:lifehack) { FactoryGirl.create(:lifehack) }
  let!(:reviews) { FactoryGirl.create_list(:review, 4, lifehack: lifehack) }
  let(:user) { FactoryGirl.create(:user) }

  scenario 'user sees lifehack details and latest 3 reviews for lifehack' do

    old_review = reviews.shift

    user_sign_in(user)
    visit lifehack_path(lifehack)

    expect(page).to have_link 'Add Review'

    reviews.each do |review|
      within "div.review-#{review.id}" do
        expect(page).to have_content(review.rating)
        expect(page).to have_content(review.comment)
      end
    end

    expect(page).to_not have_content(old_review.comment)
  end
end
