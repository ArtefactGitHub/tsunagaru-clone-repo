class RoomNotifier < ActiveRecord::Migration[5.2]
  def change
    create_table :room_notifiers do |t|
      t.references :room, index: true
      t.references :user, index: true

      t.timestamps
    end

    add_index :room_notifiers, [:room_id, :user_id], unique: true
  end
end
