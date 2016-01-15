require 'rails_helper'
require 'spec_helper'
require 'orderly'

feature "user sees the details of a lifehack" do
  let (:user) { FactoryGirl.create(:user) }
  let! (:lifehack) { FactoryGirl.create(:lifehack) }

  before(:each) do
    user_sign_in(user)
  end

  scenario "sees the details" do
    visit lifehacks_path
    click_on(lifehack.title)
    expect(page).to have_content(lifehack.title)
    expect(page).to have_content(lifehack.url)
    expect(page).to have_content(lifehack.description)
    expect(page).to have_content(lifehack.creator.first_name)
    expect(page).to have_content(lifehack.creator.last_name)
    expect(page).to have_content(lifehack.avg_review_rating)
    expect(page).to have_content(lifehack.reviews.count)
  end

  scenario "navigates back to index page" do
    visit lifehack_path(lifehack)
    click_link("Home")

    expect(current_path).to eq(lifehacks_path)
    expect(page).to have_content("#{lifehack.title}")
  end

  scenario "user views creator of lifehack" do
    within '.lifehacklist' do
      click_link lifehack.creator.full_name
    end

    expect(current_path).to eq(user_path(lifehack.creator))
    expect(page).to have_content("Name: #{lifehack.creator.full_name}")
    expect(page).to have_content("Email: #{lifehack.creator.email}")
  end
end
