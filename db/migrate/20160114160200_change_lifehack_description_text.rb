class ChangeLifehackDescriptionText < ActiveRecord::Migration
  def up
    change_column :lifehacks, :description, :text
  end

  def down
    change_column :lifehacks, :description, :string
  end
end
