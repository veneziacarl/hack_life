require 'rails_helper'

RSpec.describe User, type: :model do
  it 'calculates the sum of vote scores' do
    review = FactoryGirl.create(:review)
    FactoryGirl.create_list(:vote, 5, review: review)
    FactoryGirl.create(:vote, :down, review: review)

    expect(review.sum_score).to eq(4)
  end

  it 'calculates a score of 0 if no votes' do
    review = FactoryGirl.create(:review)
    expect(review.sum_score).to eq(0)
  end

  it 'sends a notification email' do
    ActionMailer::Base.deliveries.clear
    FactoryGirl.build(:review)
    expect(ActionMailer::Base.deliveries.size).to eq(1)
  end
end
