class Lifehack < ActiveRecord::Base
  belongs_to :creator, class_name: 'User'
  has_many :reviews
  validates :title, presence: true
  before_validation :strip_whitespace

  def short_description
    unless description.nil? || description.empty?
      desired_length = 40
      short_descr = ""
      description.split('').each_with_index.map do |char, index|
        short_descr << char if index < desired_length
      end
      short_descr
    end
  end

  private

  def strip_whitespace
    title.strip unless title.nil?
  end
end
