class AddUpdatedAtMessageToRooms < ActiveRecord::Migration[5.2]
  def change
    add_column :rooms, :updated_at_message, :datetime, :default => nil
  end
end
