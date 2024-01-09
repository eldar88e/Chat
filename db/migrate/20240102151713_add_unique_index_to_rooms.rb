class AddUniqueIndexToRooms < ActiveRecord::Migration[7.1]
  def change
    add_index :memberships, [:user_id, :room_id], unique: true
  end
end
