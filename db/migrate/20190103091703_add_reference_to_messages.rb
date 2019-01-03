class AddReferenceToMessages < ActiveRecord::Migration[5.2]
  def change
    add_reference :messages, :user
    add_reference :messages, :room
  end
end
