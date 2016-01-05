class CreateLifehacks < ActiveRecord::Migration
  def change
    create_table :lifehacks do |t|
      t.string :title, null: false
      t.string :description
      
      t.timestamps null: false

    end
  end
end
