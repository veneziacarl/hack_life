require 'rails_helper'

RSpec.describe ReviewSeeder, type: :model do
  let!(:lifehack) { FactoryGirl.create(:lifehack) }
  it 'creates a comment' do
    expect(ReviewSeeder.make_review).to be_a(String)
  end

  it 'seeds comments for lifehacks' do
    ReviewSeeder.seed_comments
    expect(Review.all.count).to eq 10
  end
end
