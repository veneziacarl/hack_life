require 'factory_girl_rails'

FactoryGirl.define do
  factory :user do
    first_name "John"
    last_name "Lastly"
    sequence(:email) { |n| "user#{n}@launch.com" }
    password "SuperPWthatislong"
  end

  factory :lifehack do
    sequence(:title) { |n| "How to tie a tie#{n}?" }
    sequence(:description) { |n| "Knot it #{n}" }
  end
end
