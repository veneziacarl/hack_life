require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_valid(:first_name).when('John', 'Sally') }
  it { should_not have_valid(:first_name).when(nil, '') }

  it { should have_valid(:last_name).when('Smith', 'Swanson') }
  it { should_not have_valid(:last_name).when(nil, '') }

  it { should have_valid(:email).when('user@example.com', 'another@gmail.com') }
  it { should_not have_valid(:email).when(nil, '', 'us', 'us@com', 'us.com') }

  it 'has a matching password confirmation for the password' do
    user = User.new
    user.password = 'password'
    user.password_confirmation = 'anotherpassword'

    expect(user).to_not be_valid
    expect(user.errors[:password_confirmation]).to_not be_blank
  end

  it 'identifies whether user has voted on a review' do
    user_list = FactoryGirl.create_list(:user, 2)
    review = FactoryGirl.create(:review)
    FactoryGirl.create(:vote, user: user_list.first, review: review)

    expect(user_list.first.has_vote?(review)).to eq(true)
    expect(user_list.last.has_vote?(review)).to eq(false)
  end

  it 'finds the correct vote for a user and review' do
    user = FactoryGirl.create(:user)
    rev_list = FactoryGirl.create_list(:review, 2)
    vote_first = FactoryGirl.create(:vote, user: user, review: rev_list.first)
    vote_last = FactoryGirl.create(:vote, user: user, review: rev_list.last)

    expect(user.find_vote_for_review(rev_list.first)).to eq(vote_first)
    expect(user.find_vote_for_review(rev_list.last)).to eq(vote_last)
  end
end
