require 'rails_helper'
require 'spec_helper'
require 'orderly'

# - [] I should be able to click on a Lifehack list item on the index page to be brought to the show page for that individual Lifehack
# - [] I should be able to see all details about the lifehack
# - [] I should be able to see all reviews of the lifehack
# - [] I should be able to sort reviews by votes and date
# - [] I should be able to click a link to navigate back to the index page

feature "user sees the details of a lifehack" do
  scenario "sees the details" do

    first_lifehack = FactoryGirl.create(:lifehack)
    second_lifehack = FactoryGirl.create(:lifehack)

    visit lifehacks_path

    expect(page).to have_content("#{first_lifehack.created_at.strftime("%m/%d/%Y")} #{first_lifehack.created_at.strftime("%I:%M%p")}")
    expect("#{second_lifehack.title}").to appear_before("#{first_lifehack.title}")

    click-on("#{first_lifehack.title}")

    visit lifehack_path(lifehack)

    expect(page).to have_content(first_lifehack.title)
    expect(page).to have_content(first_lifehack.description)
    expect(page).to have_content(first_lifehack.creator)
  end

  scenario "navigates back to index page" do

    first_lifehack = FactoryGirl.create(:lifehack)
    second_lifehack = FactoryGirl.create(:lifehack)

    visit lifehack_path(lifehack)

    expect(page).to have_content(first_lifehack.title)
    expect(page).to have_content(first_lifehack.description)

    click_link("Home Page")
    visit lifehacks_path

    expect(page).to have_content("#{first_lifehack.first_lifehack.title}")
    expect(page).to have_content("#{first_lifehack.second_lifehack.title}")
  end

  scenario "sees reviews for specific lifehack" do
    first_lifehack = FactoryGirl.create(:lifehack)
    second_lifehack = FactoryGirl.create(:lifehack)

    visit lifehack_path(lifehack)

    expect(page).to have_content review.name
    expect(page).to have_content review_for_launch.rating
    expect(page).to have_content review_for_launch.body
    expect(page).to have_content review_for_launch.created_at.strftime("%B %d %Y")
  end

  scenario "does not see other reviews for other lifehacks" do

    first_lifehack = FactoryGirl.create(:lifehack)
    second_lifehack = FactoryGirl.create(:lifehack)

    visit lifehack_path(lifehack)

    expect(page).to have_content starbucks.name
    expect(page).to have_content review_for_starbucks.body

    expect(page).not_to have_content review_for_launch.rating
    expect(page).not_to have_content review_for_launch.body
  end
end
