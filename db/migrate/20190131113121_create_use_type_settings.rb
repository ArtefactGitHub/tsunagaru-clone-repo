class CreateUseTypeSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :use_type_settings do |t|
      t.integer :use_type, default: 0
      t.boolean :use_text_input, default: false, null: false
      t.boolean :use_button_input, default: false, null: false
      t.references :user, index: true

      t.timestamps
    end
  end
end
