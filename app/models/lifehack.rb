class Lifehack < ActiveRecord::Base
  belongs_to :creator, class_name: 'User'
  has_many :reviews
  validates :title, presence: true

  before_validation :strip_whitespace

  private

  def strip_whitespace
    title = self.title
    title = title.strip unless title.nil?
  end
end
