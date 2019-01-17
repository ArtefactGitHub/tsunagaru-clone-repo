class AddUuidIndexToUsers < ActiveRecord::Migration[5.2]
  def change
    add_index :users, :uuid, unique: true
  end
end
