class CreateMessageButtonLists < ActiveRecord::Migration[5.2]
  def change
    create_table :message_button_lists do |t|
      t.references :room, index: true

      t.timestamps
    end
  end
end
