class AddUseMailNotifyToUseTypeSettings < ActiveRecord::Migration[5.2]
  def change
    add_column :use_type_settings, :use_mail_notification, :boolean, default: false
  end
end
