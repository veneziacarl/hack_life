require 'factory_girl_rails'

FactoryGirl.define do
  factory :user do
    first_name "John"
    last_name "Lastly"
    sequence(:email) { |n| "user#{n}@launch.com" }
    password "SuperPWthatislong"

    trait :bot do
      first_name "Lifehack"
      last_name "Bot"
      email "lifehackbot@gmail.com"
      password "lifehackbot"
      profile_photo do
        Rack::Test::UploadedFile.new(
          File.join(Rails.root, 'spec', 'support', 'images', 'bot_image.png'))
      end
      role "admin"
    end

    trait :image do
      sequence(:first_name) { UserSeeder.fake_name.first }
      sequence(:last_name) { UserSeeder.fake_name.last }
      sequence(:email) do |n|
        "#{UserSeeder.fake_email[1]}#{n}#{UserSeeder.fake_email[2]}"
      end
      profile_photo do
        Rack::Test::UploadedFile.new(
          File.join(Rails.root, 'spec', 'support', 'images', UserSeeder.f_phot))
      end
    end

    trait :admin do
      role "admin"
    end
  end
end
