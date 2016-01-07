class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.belongs_to :user, null: false
      t.belongs_to :review, null: false, index: true
      t.integer :score, null: false

      t.timestamps null: false
    end
  end
end
