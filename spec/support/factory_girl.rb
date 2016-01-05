FactoryGirl.define do

  factory :lifehack do
    sequence(:title) {|n| "How to tie a tie#{n}?" }
    sequence(:description) { |n| "Knot it #{n}" }
  end
end
