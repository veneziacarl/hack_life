class AddUrlToLifehack < ActiveRecord::Migration
  def change
    add_column :lifehacks, :url, :text
  end
end
