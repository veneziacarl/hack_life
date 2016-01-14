class VoteSeeder
  def self.seed_votes
    reviews = Review.all
    reviews.each do |review|
      VoteSeeder.fake_review_votes(review)
    end
  end

  def self.fake_review_votes(review)
    users = User.all
    user_count = users.count

    number_of_votes = rand(user_count)
    up_vote_users = users.sample(number_of_votes)
    up_vote_users.each do |user|
      FactoryGirl.create(:vote, review: review, user: user)
    end
    other_users = users - up_vote_users
    other_users_count = other_users.count
    down_vote_users = other_users.sample((other_users_count/2).floor)
    down_vote_users.each do |user|
      FactoryGirl.create(:vote, :down, review: review, user: user)
    end
  end
end
