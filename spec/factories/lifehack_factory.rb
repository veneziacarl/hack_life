require 'factory_girl_rails'

FactoryGirl.define do
  factory :lifehack do
    sequence(:title) { |n| "How to tie a tie#{n}" }
    sequence(:description) { |n| "Knot it #{n}" }
    association :creator, factory: :user
  end
end
