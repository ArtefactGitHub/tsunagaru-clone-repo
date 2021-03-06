class CreateMessageButtons < ActiveRecord::Migration[5.2]
  def change
    create_table :message_buttons do |t|
      t.string :content, limit: 20
      t.integer :message_no
      t.integer :message_type, default: 0
      t.references :message_button_list, index: true

      t.timestamps
    end
  end
end
