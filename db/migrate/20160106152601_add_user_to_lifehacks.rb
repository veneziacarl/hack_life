class AddUserToLifehacks < ActiveRecord::Migration
  def change
    add_reference :lifehacks, :creator, index: true
  end
end
