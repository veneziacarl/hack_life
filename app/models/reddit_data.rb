class RedditData
  attr_accessor :subreddit

  def initialize(subreddit)
    @subreddit = subreddit
  end

  def get_posts
    uri_string ="https://www.reddit.com/r/#{subreddit}.json"
    uri = URI(uri_string)
    response = Net::HTTP.get(uri)

    JSON.parse(response)
  end

  def parse
    data = get_posts
    output = []
    data['data']['children'].each do |post|
      unless post['data']['stickied']
        title = post['data']["title"]
        url = post['data']['permalink']
        description = post['data']['selftext']
        output << { 'Title' => title, 'URL' => url, 'Description' => description}
      end
    end
    output
  end
end
