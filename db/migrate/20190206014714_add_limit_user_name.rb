class AddLimitUserName < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :name, :string, limit: 20
  end
end
