class Users::OauthsController < ApplicationController
  before_action :require_login, only: %i[destroy]
  before_action :set_provider_name, only: %i[callback new]

  # sends the user on a trip to the provider,
  # and after authorizing there back to the callback url.
  def oauth
    login_at(params[:provider])
  end

  def callback
    denied_app_collaborate and return if params[:denied].present?

    begin
      @user = login_from(@provider_name)
      return redirect_to root_path if @user.present?
    rescue OAuth::Unauthorized => e
      logger.error(e)
      redirect_to root_path and return
    end

    setup_user_instance @provider_name
    render :new
  end

  def new
    setup_user_instance @provider_name
  end

  def create
    @user = User.new(user_params)
    # SNS認証の場合はパスワードを自動で入力してバリデーションを通す
    @user.assign_password
    @user.download_and_attach_avatar

    # new アクションで実行した create_and_validate_from() の中でセッションに保存したパラメータを取得し、認証クラスの生成に用いる
    # （add_provider_to_user() で生成する方法は「401 Authorization Required」が解決出来なかった）
    @user.authentications.build(session[:incomplete_user]['provider'])

    if @user.save
      reset_session # protect from session fixation attack
      auto_login(@user)
      redirect_to about_url, success: 'ユーザーを作成しました'
    else
      # エラーオブジェクトを消さないとチェックボックスのチェックができなくなる
      @user.errors.clear
      flash.now[:danger] = 'ユーザーが作成出来ませんでした'
      render :new
    end
  end

  private

  def user_params
    # params.require(:user).permit(:name, :screen_name, :email, :profile, :profile_image_url, :avatar, like_area_ids: [])
    params.require(:user).permit(:name, :screen_name, :email, :profile, :profile_image_url)
  end

  # アプリ連携を拒否
  def denied_app_collaborate
    logger.error('authenticate denied')
    redirect_to login_url
  end

  def setup_user_instance(provider_name)
    # see https://github.com/NoamB/sorcery/blob/master/lib/sorcery/controller/submodules/external.rb
    @user = create_and_validate_from provider_name
    # エラーオブジェクトを消さないとチェックボックスのチェックができなくなる
    @user.errors.clear
  end

  # TODO: Twitter で決め打ち指定
  # Twitter 認証のコールバックでクエリ文字を含めることが出来ず、
  # oauth/request_tokenリクエストが必要になるようなので、ひとまず決め打ち指定で実装
  def set_provider_name
    @provider_name = :twitter
  end
end
