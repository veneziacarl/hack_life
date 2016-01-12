require 'rails_helper'
require 'spec_helper'
require 'orderly'

# [ ] I should see an index of all lifehacks at the root of the app
# [ ] I should see the title, date
# [ ] I should see the creator (add this in once user is built)
# [ ] I should see a list sorted by date by default

feature "user sees list of lifehacks" do

  let!(:lifehack) { FactoryGirl.create(:lifehack) }
  let!(:lifehack2) { FactoryGirl.create(:lifehack) }

  scenario "see all the lifehacks" do
    visit root_path

    expect(page).to have_content(lifehack.title)
    expect(page).to have_content("#{lifehack.created_at.strftime('%m/%d/%Y')}
    #{lifehack.created_at.strftime('%I:%M%p')}")
    expect("#{lifehack2.title}").to appear_before("#{lifehack.title}")
    expect(page).to have_content "Submitted By: #{lifehack.creator.first_name}"
  end
end
