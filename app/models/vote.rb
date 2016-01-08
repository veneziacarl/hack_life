class Vote < ActiveRecord::Base
  SCORE_OPTIONS = [1, 0, -1]
  belongs_to :user
  belongs_to :review

  validates :user, presence: true
  validates :review, presence: true
  validates :score,
    presence: true,
    numericality: { only_integer: true }, inclusion: { in: SCORE_OPTIONS }
  validates :user, uniqueness: { scope: :review }
end
