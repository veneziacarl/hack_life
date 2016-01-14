require 'rails_helper'

RSpec.describe VoteSeeder, type: :model do
  let!(:reviews) { FactoryGirl.create_list(:review, 4) }
  it 'creates votes' do
    VoteSeeder.seed_votes
    expect(Vote.all.count).to be > 0
  end
end
