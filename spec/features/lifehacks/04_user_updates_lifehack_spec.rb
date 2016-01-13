require 'rails_helper'
feature 'user updates lifehack', %{
  As a User and the creator of the lifehack
  I want to edit the lifehack
  So I can update the content of the lifehack
} do

  # Acceptance Criteria:
  # [√] I must provide all of the required information
  # [√] If the information is incorrect, I must be provided errors
  # [√] If I am not logged in, I cannot modify the content of the lifehack
  # [√] If I am not the creator, I cannot modify the content of the lifehack

  let (:user) { FactoryGirl.create(:user) }
  let!(:lh) { FactoryGirl.create(:lifehack, creator: user) }
  let (:user2) { FactoryGirl.create(:user) }

  scenario 'navigate to lifehack show page and edit lifehack' do
    user_sign_in(user)
    click_link(lh.title)

    expect(current_path).to eq(lifehack_path(lifehack))

    click_link('Edit Lifehack')

    expect(find_field('lh[title]').value).to eq(lh.title)
    expect(find_field('lh[description]').value).to eq(lh.description)

    title = 'Hopefully this work'
    description = 'Testing out this cool new edition to the lifehack'
    fill_in('lh[title]', with: title)
    fill_in('lh[description]', with: description)
    click_button('Add Lifehack')

    expect(current_path).to eq(lifehack_path(lh))
    expect(page).to have_content(title)
    expect(page).to have_content(description)
    expect(page).to have_content('Lifehack Edited Successfully!')
  end

  scenario 'user attempts to post an invalid title' do
    user_sign_in(user)
    click_link(lh.title)
    click_link('Edit Lifehack')

    expect(find_field('lh[title]').value).to eq(lh.title)
    expect(find_field('lh[description]').value).to eq(lh.description)

    description = 'How fast can I type this without making a mistake'
    fill_in('lh[title]', with: '')
    fill_in('lh[description]', with: description)
    click_button('Add Lifehack')

    expect(find_field('lh[title]').value).to eq('')
    expect(find_field('lh[description]').value).to eq(description)
  end

  scenario 'user attempts to edit another user\'s lifehack' do
    user_sign_in(user2)
    click_link(lh.title)
    click_link('Edit Lifehack')

    expect(page).to have_content('You are not the Authorized User')
  end
end
