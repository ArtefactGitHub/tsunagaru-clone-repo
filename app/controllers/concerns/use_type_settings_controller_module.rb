module UseTypeSettingsControllerModule
  extend ActiveSupport::Concern

  def create_use_type_setting(owner)
    setting = UseTypeSetting.new
    setting.user = owner
    setting.setup_optional
    setting.save!
  end
end
