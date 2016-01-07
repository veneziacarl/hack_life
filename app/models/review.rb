class Review < ActiveRecord::Base
  RATING_LIST = [1, 2, 3, 4, 5]
  
  belongs_to :lifehack
  has_many :votes
  belongs_to :creator, class_name: 'User'

  validates :rating,
    presence: true,
    numericality: { only_integer: true }, inclusion: { in: RATING_LIST }

  def sum_score
    score = votes.map { |vote| vote.score }.reduce(:+)
    score || 0
  end
end
