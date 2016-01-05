class Review < ActiveRecord::Base
  validates :rating,
    presence: true,
    numericality: { only_integer: true },
    inclusion: { in: (1..5) }

  RATING_LIST = [1, 2, 3, 4, 5]
end
