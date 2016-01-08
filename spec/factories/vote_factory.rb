require 'factory_girl_rails'

FactoryGirl.define do
  factory :vote do
    user
    review
    score "1"

    trait :down do
      score "-1"
    end
  end
end
