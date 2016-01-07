class User < ActiveRecord::Base
  has_many :lifehacks
  validates :first_name, presence: true
  validates :last_name, presence: true
  has_many :votes
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable
  mount_uploader :profile_photo, ProfilePhotoUploader
    
  def has_vote?(review)
    votes.any? { |vote| vote.review_id == review.id }
  end

  def find_vote_for_review(review)
    votes.detect { |vote| vote.review_id == review.id }
  end
end
