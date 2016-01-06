class LifehackReviewsAssociation < ActiveRecord::Migration
  def change
    add_reference :reviews, :lifehack, index: true, null: false
  end
end
