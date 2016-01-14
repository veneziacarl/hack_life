require 'rails_helper'

RSpec.describe RedditData, type: :model do
  let(:lpt_data) { RedditData.new('LifeProTips') }
  it 'receives json data from reddit' do
    expect(lpt_data.get_posts['kind']).to eq('Listing')
  end

  it 'receives data from LPT subreddit' do
    lpt_data.get_posts['data']['children'].each do |post|
      expect(post['data']['subreddit']).to eq ('LifeProTips')
    end
  end

  it 'parses and the posts' do
    lpt_data.parse.each do |post|
      expect(post['Title']).to_not be_blank
      expect(post['URL']).to_not be_blank
    end
  end
end
