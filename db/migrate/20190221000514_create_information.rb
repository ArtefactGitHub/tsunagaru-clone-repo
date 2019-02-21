class CreateInformation < ActiveRecord::Migration[5.2]
  def change
    create_table :information do |t|
      t.text :title, null: false
      t.text :content, null: false
      t.integer :order, default: 0
      t.integer :information_type, default: 0

      t.timestamps
    end
  end
end
