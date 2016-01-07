class Review < ActiveRecord::Base
  belongs_to :lifehack
  belongs_to :creator, class_name: 'User' 
  RATING_LIST = [1, 2, 3, 4, 5]

  validates :rating,
    presence: true,
    numericality: { only_integer: true }, inclusion: { in: RATING_LIST }
end
