class ReviewSeeder
  FAKESTUFF = [Faker::Avatar.image, Faker::University.name, Faker::Internet.email, Faker::Hacker.say_something_smart, Faker::Lorem.sentence, Faker::Company.catch_phrase, Faker::Company.bs, Faker::Commerce.product_name, Faker::Commerce.department(3)]

  def self.seed_reviews(num = 10)
    lifehacks = Lifehack.all
    users = FactoryGirl.create_list(:user, num, :image)

    (lifehacks.count * num).times do
      lifehack = lifehacks.sample
      rating = rand(5) + 1
      user = User.all.sample
      review = Review.create!(rating: rating, comment: ReviewSeeder.make_comment, lifehack: lifehack, creator: user)
    end
  end

  def self.make_comment
    comment = []
    (rand(5)+1).times do
      comment << "#{FAKESTUFF.sample}"
    end
    comment.join(" ")
  end
end
