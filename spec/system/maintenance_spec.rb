require 'rails_helper'

describe 'メンテナンス中の挙動の確認', type: :system do
  describe 'ログイン' do
    let(:user_a) { create(:user, name: 'ユーザーA', email: 'a@g.com') }

    context 'メンテ中に非管理者ユーザーがログインした時' do
      before do
        with_env_vars(CAN_LOGIN: 'false') do
          login_user(user_a.email, 'password')
        end
      end

      it 'マイページに遷移しない' do
        # take_full_page_screenshot 'login_spec/メンテ中に非管理者ユーザーがログインした時、マイページに遷移しない.png'
        expect(page).to have_content 'メンテナンス中のため'
        expect(page).not_to have_content 'ホーム画面'
      end
    end

    context 'メンテ中に管理者ユーザーがログインした時' do
      let(:admin_user) { create(:user, :admin, name: '管理者', email: 'admin@g.com') }
      before do
        with_env_vars(CAN_LOGIN: 'false') do
          login_user(admin_user.email, 'password')
        end
      end

      it 'マイページに遷移している' do
        # take_full_page_screenshot 'login_spec/メンテ中に非管理者ユーザーがログインした時、マイページに遷移しない.png'
        expect(page).to have_content 'ホーム画面'
      end
    end
  end
end
