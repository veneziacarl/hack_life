feature 'user gets email when someone reviews their lifehack', %{
  As a User
  I want to get an email notification when someone reviews my lifehack
  So I can see what community members think of my lifehack
} do

  # Acceptance Criteria:
  # [x] I get an email when someone reviews my lifehack.

  let (:user) { FactoryGirl.create(:user) }
  let (:lifehack) { FactoryGirl.create(:lifehack) }

  xscenario 'user recieves notification of rating and comment on lifehack' do

    user_sign_in(user)
    visit lifehack_path(lifehack)
    click_link 'Add Review'

    within('.rating') { choose '5' }
    fill_in 'Comment', with: 'testcomment'
    click_button 'Add Review'

    expect(page).to have_content('Review made!')
    expect(page).to have_content('Rating')
    expect(page).to have_content('5')
    expect(page).to have_content('testcomment')
    expect(ActionMailer::Base.deliveries.count).to eq(1)
  end

  xscenario 'user receives notification of rated lifehack' do

    user_sign_in(user)
    visit lifehack_path(lifehack)
    click_link 'Add Review'

    within('.rating') { choose '5' }
    click_button 'Add Review'

    expect(page).to have_content('Review made!')
    expect(page).to have_content('Rating')
    expect(page).to have_content('5')
    expect(ActionMailer::Base.deliveries.count).to eq(1)
  end

  xscenario 'user recieves notification of comment on lifehack' do

    user_sign_in(user)
    visit lifehack_path(lifehack)
    click_link 'Add Review'

    fill_in 'Comment', with: 'testcomment'
    click_button 'Add Review'
    expect(page).to have_content("Review rating can't be blank!")

    visit lifehack_path(lifehack)

    expect(page).to_not have_content('testcomment')
    expect(ActionMailer::Base.deliveries.count).to eq(0)
  end
end
