class VotesUniqueUserAndReview < ActiveRecord::Migration
  def up
    add_index :votes, [:user_id, :review_id], unique: true
  end

  def down
    remove_index :votes, [:user_id, :review_id]
  end
end
