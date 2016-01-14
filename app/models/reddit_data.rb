class RedditData
  attr_accessor :subreddit
  attr_reader :data

  def initialize(subreddit)
    @subreddit = subreddit
    @data = nil
  end

  def get_posts
    uri_string ="https://www.reddit.com/r/#{subreddit}.json"
    uri = URI(uri_string)
    response = Net::HTTP.get(uri)

    @data = JSON.parse(response)
  end

  def parse
    unless @data
      get_posts
    end
    output = []
    @data['data']['children'].each do |post|
      unless post['data']['stickied']
        title = post['data']["title"]
        url = post['data']['permalink']
        description = post['data']['selftext']
        output << { 'Title' => title, 'URL' => url, 'Description' => description}
      end
    end
    output
  end

  def seed_db
    unless @data
      get_posts
    end
    bot = User.find_or_create_by(email: "lifehackbot@gmail.com") do |user|
      user.first_name = "Lifehack"
      user.last_name = "Bot"
      user.password = "lifehackbot"
    end
    parse.each do |post|
      Lifehack.find_or_create_by(url: post["URL"]) do |lifehack|
        lifehack.title = post["Title"]
        lifehack.description = post["Description"]
        lifehack.creator = bot
      end
    end
  end
end
