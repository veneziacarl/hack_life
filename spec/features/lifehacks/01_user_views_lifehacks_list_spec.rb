require 'rails_helper'
require 'spec_helper'
require 'orderly'

# [√] I should see an index of all lifehacks at the root of the app
# [√] I should see the title, date
# [ ] I should see the creator (add this in once user is built)
# [ ] I should see the average rating (add this in once user is built)
# [√] I should see a list sorted by date by default
# [ ] I must be able to sort by rating
# [ ] I must be able to sort by date
# [ ] I must be able to sort by category

feature "user sees list of lifehacks" do
  scenario "see all the lifehacks" do

    one_lifehack = FactoryGirl.create(:lifehack)
    sec_lifehack = FactoryGirl.create(:lifehack)

    visit lifehacks_path
    expect(page).to have_content(one_lifehack.title)

    expect(page).to have_content("#{one_lifehack.created_at.strftime('%m/%d/%Y')}
    #{one_lifehack.created_at.strftime('%I:%M%p')}")
    expect("#{sec_lifehack.title}").to appear_before("#{one_lifehack.title}")
    expect(page).to have_content "Submitted By:"
    expect(page).to have_content "Average Rating:"
  end
end
