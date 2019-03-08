class Users::OauthsController < ApplicationController
  include CreateUserModule

  before_action :require_login, only: %i[destroy]
  before_action :set_provider_name, only: %i[callback new]
  skip_before_action :check_maintenance

  # sends the user on a trip to the provider,
  # and after authorizing there back to the callback url.
  def oauth
    login_at(params[:provider])
  end

  def callback
    denied_app_collaborate and return if params[:denied].present?

    begin
      @user = login_from(@provider_name)

      # ログイン時のメンテナンス判定
      if @user.present?
        return redirect_if_maintenance_on_login unless can_login_with_email? @user.email

        return redirect_to root_path
      end
    rescue OAuth::Unauthorized => e
      logger.error(e)
      redirect_to root_path and return
    end

    # ユーザー登録時のメンテナンス判定
    return redirect_if_maintenance unless env_can_create_user?

    setup_user_instance @provider_name
    render :new
  end

  def new
    setup_user_instance @provider_name
  end

  def create
    @user = User.new(user_params)

    before_save_for_oauth session[:incomplete_user]['provider']

    if @user.save
      after_save_for_oauth

      # メンテナンス時、ユーザー登録が行える状況でもログインは行えない
      return redirect_if_maintenance unless env_can_login?

      # reset_session # protect from session fixation attack
      auto_login(@user, params.dig(:remember))
      redirect_to mypage_root_url, success: 'ユーザーを作成しました'
    else
      flash.now[:danger] = 'ユーザーが作成出来ませんでした'
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :screen_name, :email, :introduction, :remember, :profile_image_url)
  end

  # アプリ連携を拒否
  def denied_app_collaborate
    logger.error('authenticate denied')
    redirect_to login_url
  end

  def setup_user_instance(provider_name)
    # see https://github.com/NoamB/sorcery/blob/master/lib/sorcery/controller/submodules/external.rb
    @user = create_and_validate_from provider_name
    # 故意に発生させたエラーを消しておく
    @user.errors.clear
  end

  # TODO: Twitter で決め打ち指定
  # Twitter 認証のコールバックでクエリ文字を含めることが出来ず、
  # oauth/request_tokenリクエストが必要になるようなので、ひとまず決め打ち指定で実装
  def set_provider_name
    @provider_name = :twitter
  end
end
