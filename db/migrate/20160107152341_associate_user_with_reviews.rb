class AssociateUserWithReviews < ActiveRecord::Migration
  def change
    add_reference :reviews, :creator, index: true, null: false
  end
end
