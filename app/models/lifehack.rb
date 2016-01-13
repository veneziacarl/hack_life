class Lifehack < ActiveRecord::Base
  belongs_to :creator, class_name: 'User'
  has_many :reviews
  validates :title, presence: true
  before_validation :strip_whitespace

  paginates_per 10

  private

  def strip_whitespace
    title.strip unless title.nil?
  end
end
