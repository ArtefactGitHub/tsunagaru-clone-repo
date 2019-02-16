class AddScreenNameToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :screen_name, :string, default: ''
  end
end
