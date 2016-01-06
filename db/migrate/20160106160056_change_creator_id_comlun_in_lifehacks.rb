class ChangeCreatorIdComlunInLifehacks < ActiveRecord::Migration
  def change
    change_column_null :lifehacks, :creator_id, false
  end
end
