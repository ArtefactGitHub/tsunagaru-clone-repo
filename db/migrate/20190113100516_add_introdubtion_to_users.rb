class AddIntrodubtionToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :introduction, :text, limit: 1000
  end
end
