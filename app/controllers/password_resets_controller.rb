class PasswordResetsController < ApplicationController
  skip_before_action :require_login
  before_action :set_token_and_user, only: %i[edit update]

  def new; end

  # request password reset.
  # you get here when the user entered his email in the reset password form and submitted it.
  def create
    @user = User.find_by(email: params[:email])

    # This line sends an email to the user with instructions on how to reset their password (a url with a random token)
    @user.deliver_reset_password_instructions! if @user

    # Tell the user instructions have been sent whether or not email was found.
    # This is to not leak information to attackers about which emails exist in the system.
    redirect_to root_path, success: '入力されたメールアドレスへパスワード初期化のお知らせを送信しました'
  end

  # This is the reset password form.
  def edit
    return not_authenticated if @user.blank?
  end

  # This action fires when the user has sent the reset password form.
  def update
    return not_authenticated if @user.blank?

    # the next line makes the password confirmation validation work
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.valid?
      # the next line clears the temporary token and updates the password
      @user.change_password! params[:user][:password]
      redirect_to root_path, success: 'パスワードを再設定しました'
    else
      flash.now[:danger] = 'パスワードが設定出来ません'
      render :edit
    end
  end

  private

  def set_token_and_user
    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])
  end
end
