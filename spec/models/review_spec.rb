require 'rails_helper'

RSpec.describe User, type: :model do
  it 'calculates the sum of vote scores' do
    review = FactoryGirl.create(:review)
    FactoryGirl.create_list(:vote, 5, review: review)
    FactoryGirl.create(:vote, :down, review: review)

    expect(review.sumScore).to eq(4)
  end

  it 'calculates a score of 0 if no votes' do
    review = FactoryGirl.create(:review)
    expect(review.sumScore).to eq(0)
  end
end
