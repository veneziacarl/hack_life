class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :review

  SCORE_OPTIONS = [1, 0, -1]

  validates :user, presence: true
  validates :review, presence: true
  validates :score,
    presence: true,
    numericality: { only_integer: true}, inclusion: { in: SCORE_OPTIONS }
  validates_uniqueness_of :user, scope: :review
end
