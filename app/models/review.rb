class Review < ActiveRecord::Base
  RATING_LIST = [1, 2, 3, 4, 5]

  validates :rating,
    presence: true,
    numericality: { only_integer: true }, inclusion: { in: RATING_LIST }
end