class CreateFriendRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :friend_requests do |t|
      t.integer :own_id
      t.integer :opponent_id
      t.integer :friend_request_status, default: 0
      t.timestamps
    end

    add_index :friend_requests, :own_id
    add_index :friend_requests, :opponent_id
    add_index :friend_requests, [:own_id, :opponent_id], unique: true
  end
end
