class DeleteRoomNotifier < ActiveRecord::Migration[5.2]
  def change
    drop_table :room_notifiers
  end
end
