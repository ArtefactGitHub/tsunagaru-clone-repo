class AddPostToOperationSentAtToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :post_to_operation_sent_at, :datetime, :default => nil
  end
end
