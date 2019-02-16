module CreateUserModule
  include RoomsControllerModule
  include UseTypeSettingsControllerModule
  extend ActiveSupport::Concern

  def before_save
    @user.set_uuid
  end

  def before_save_for_oauth(provider)
    before_save

    # SNS認証の場合はパスワードを自動で入力してバリデーションを通す
    @user.assign_password

    # new アクションで実行した create_and_validate_from() の中でセッションに保存したパラメータを取得し、認証クラスの生成に用いる
    # （add_provider_to_user() で生成する方法は「401 Authorization Required」が解決出来なかった）
    @user.authentications.build provider

    # carrierwave 利用のため、save 前にアバター画像を取得しておく
    @user.setup_attach_avatar
  end

  def after_save
    create_owner_room @user
    create_use_type_setting @user
  end

  def after_save_for_oauth
    after_save

    reset_session # protect from session fixation attack
  end
end
