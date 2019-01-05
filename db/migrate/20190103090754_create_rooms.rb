class CreateRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :rooms do |t|
      t.string 'name'
      t.text 'description', limit: 1000

      t.timestamps
    end
  end
end
