require 'rails_helper'

RSpec.describe RedditData, type: :model do
  let(:lpt_data) { RedditData.new('LifeProTips') }
  let!(:lifehack_creator) { FactoryGirl.create(:user, :bot) }
  it 'receives json data from reddit' do
    expect(lpt_data.get_posts['kind']).to eq('Listing')
  end

  it 'receives data from LPT subreddit' do
    lpt_data.get_posts['data']['children'].each do |post|
      expect(post['data']['subreddit']).to eq('LifeProTips')
    end
  end

  it 'parses and the posts' do
    lpt_data.parse.each do |post|
      expect(post['Title']).to_not be_blank
      expect(post['URL']).to_not be_blank
    end
  end

  it 'adds entries from LPT subreddit into the database' do
    lpt_data.seed_db
    lpt_data.parse.each do |post|
      expect(Lifehack.find_by(url: post["URL"])).to be_a(Lifehack)
    end
  end
end
