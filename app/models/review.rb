class Review < ActiveRecord::Base
  belongs_to :lifehack
  has_many :votes
  RATING_LIST = [1, 2, 3, 4, 5]

  validates :rating,
    presence: true,
    numericality: { only_integer: true }, inclusion: { in: RATING_LIST }

  def sum_score
    score = votes.map { |vote| vote.score }.reduce(:+)
    score || 0
  end
end
