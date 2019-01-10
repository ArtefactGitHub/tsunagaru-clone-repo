class CreateFriends < ActiveRecord::Migration[5.2]
  def change
    create_table :friends do |t|
      t.integer :own_id
      t.integer :opponent_id
      t.integer :status, default: 0
      t.timestamps
    end

    add_index :friends, :own_id
    add_index :friends, :opponent_id
    add_index :friends, [:own_id, :opponent_id], unique: true
  end
end
