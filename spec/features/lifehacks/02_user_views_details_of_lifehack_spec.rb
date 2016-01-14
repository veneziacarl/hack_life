require 'rails_helper'
require 'spec_helper'
require 'orderly'

feature "user sees the details of a lifehack" do
  let (:user) { FactoryGirl.create(:user) }
  let! (:lifehack) { FactoryGirl.create(:lifehack) }

  scenario "sees the details" do
    user_sign_in(user)
    visit lifehacks_path
    click_on(lifehack.title)

    expect(page).to have_content(lifehack.title)
    expect(page).to have_content(lifehack.url)
    expect(page).to have_content(lifehack.description)
    expect(page).to have_content(lifehack.creator.first_name)
    expect(page).to have_content(lifehack.creator.last_name)
  end

  scenario "navigates back to index page" do
    user_sign_in(user)
    visit lifehack_path(lifehack)
    click_link("Home")

    expect(current_path).to eq(lifehacks_path)
    expect(page).to have_content("#{lifehack.title}")
  end
end
