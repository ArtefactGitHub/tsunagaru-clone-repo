require 'rails_helper'

describe 'ログインやログアウト', type: :system do
  describe 'ログイン' do
    let(:user_a) { create(:user, name: 'ユーザーA', email: 'a@g.com') }

    context 'ユーザーAがログインした時' do
      before do
        login_user(user_a.email, 'password')
      end

      it 'マイページに遷移している' do
        expect(page).to have_content 'ホーム画面'
      end
    end

    context 'ユーザーAがログインしていない時' do
      before do
        visit mypage_root_url
      end

      it 'マイページに遷移しない' do
        expect(page).not_to have_content 'ホーム画面'
      end
    end
  end

  describe 'ログアウト' do
    let(:user_a) { create(:user, name: 'ユーザーA', email: 'a@g.com') }

    context 'ユーザーAがログインしている時' do
      before do
        login_user(user_a.email, 'password')
      end

      it 'ログアウトするとログイン画面に遷移する' do
        click_link 'ログアウト'
        expect(current_path).to eq login_path
        expect(page).to have_content 'ログイン'
      end
    end
  end
end
