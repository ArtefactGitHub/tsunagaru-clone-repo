class CreateMessageCommand < ActiveRecord::Migration[5.2]
  def change
    create_table :message_commands do |t|
      t.string :name
      t.integer :message_type, default: 0

      t.timestamps
    end
  end
end
