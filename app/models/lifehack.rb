class Lifehack < ActiveRecord::Base
  belongs_to :creator, class_name: 'User'
  has_many :reviews
  validates :title, presence: true
  before_validation :strip_whitespace

  def short_description
    desired_length = 40
    unless description.nil? || description.strip.empty?
      short_descr = ""
      description.split('').each_with_index.map do |char, index|
        short_descr << char if index < desired_length
      end
      short_descr
    end
  end

  def self.search_all(search)
    query = "title ILIKE ? OR description ILIKE ?"
    Lifehack.where(query, "%#{search}%", "%#{search}%")
  end

  def self.search_title(search)
    query = "title ILIKE ?"
    Lifehack.where(query, "%#{search}%")
  end

  def self.search_description(search)
    query = "description ILIKE ?"
    Lifehack.where(query, "%#{search}%")
  end

  def self.search_user(search)
    query = "first_name ILIKE ? OR last_name ILIKE ?"
    if search.include?(" ")
      search = search.split(" ")
      user = User.where(query, "%#{search[0]}%", "%#{search[1]}%")
    else
      user = User.where(query, "%#{search}%", "%#{search}%")
    end
    Lifehack.where(creator: user)
  end

  def avg_review_rating
    if reviews.empty?
      avg = 0
    else
      avg = reviews.inject(0.0){ |sum, r| sum + r.rating } / reviews.size
    end
    sprintf "%.2f", avg
  end

  paginates_per 10

  private

  def strip_whitespace
    title.strip unless title.nil?
  end
end
