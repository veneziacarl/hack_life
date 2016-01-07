require 'factory_girl_rails'

FactoryGirl.define do
  factory :review do
    rating 5
    sequence(:comment) { |n| "Best lifehack ever#{n}" }
    association :lifehack
    association :creator, factory: :user
  end
end
