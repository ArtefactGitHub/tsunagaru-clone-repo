class CreateMessageButtons < ActiveRecord::Migration[5.2]
  def change
    create_table :message_buttons do |t|
      t.string :content
      t.integer :message_no
      t.integer :message_type, default: 0
      t.references :room, index: true

      t.timestamps
    end
  end
end
