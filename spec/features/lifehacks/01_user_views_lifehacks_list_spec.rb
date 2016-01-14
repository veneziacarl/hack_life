require 'rails_helper'
require 'spec_helper'
require 'orderly'

# [√] I should see an index of all lifehacks at the root of the app
# [√] I should see the title, date
# [√] I should see the creator (add this in once user is built)
# [√] I should see a list sorted by date by default

feature "user sees list of lifehacks" do
  let!(:lifehacks) { FactoryGirl.create_list(:lifehack, 11) }

  scenario "user sees the latest 10 lifehacks" do
    oldest_lifehack = lifehacks.shift

    visit root_path
    lifehacks.each do |lifehack|
      expect(page).to have_link(lifehack.title, exact: true)
      expect(page).to have_content(time_ago_in_words(lifehack.updated_at))
      expect(page).to have_link(lifehack.creator.full_name)
      expect(page).to have_content(lifehack.avg_review_rating)
      expect(page).to have_content(lifehack.reviews.count)
    end

    expect(lifehacks.last.title).to appear_before(lifehacks.first.title)

    expect(page).to_not have_link(oldest_lifehack.title, exact: true)
    expect(page).to have_link("Next ›")
  end
end
