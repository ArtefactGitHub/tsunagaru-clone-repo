class AddReferenceToRoom < ActiveRecord::Migration[5.2]
  def change
    add_reference :rooms, :owner, class_name: 'User'
  end
end
