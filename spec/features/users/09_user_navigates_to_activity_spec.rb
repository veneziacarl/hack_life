require 'rails_helper'

feature "user has an activity profile" do
  let! (:user) { FactoryGirl.create(:user) }
  let! (:lifehack) { FactoryGirl.create(:lifehack, creator: user) }
  let! (:review) { FactoryGirl.create(:review, creator: user)}

  before (:each) do
    user_sign_in(user)
    visit user_path(user)
  end

  scenario "sees their recent activity" do
    expect(page).to have_content(lifehack.title)
    expect(page).to have_content(lifehack.description)
    expect(page).to have_content(review.rating)
    expect(page).to have_content(review.comment)
  end

  scenario "navigates to recent lifehack post" do
    click_on(lifehack.title)
    expect(current_path).to eq(lifehack_path(lifehack))
    expect(page).to have_content(lifehack.title)
    expect(page).to have_content(user.full_name)
  end

  scenario "navigates to recent review post" do
    within '.reviews' do
      click_link(review.lifehack.title)
    end

    expect(current_path).to eq(lifehack_path(review.lifehack))
    expect(page).to have_content(review.lifehack.title)
    expect(page).to have_content(user.full_name)
  end
end
