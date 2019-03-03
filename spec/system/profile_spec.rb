require 'rails_helper'

describe 'プロフィール画面', type: :system do
  describe 'ログイン・未ログインの画面遷移' do
    let(:user_a) { create(:user, name: 'ユーザーA', email: 'a@g.com') }

    context 'ログイン時' do
      before do
        login_user(user_a.email, 'password')
      end

      it 'プロフィール画面に遷移出来る' do
        visit edit_mypage_user_user_path user_a
        expect(page).to have_content 'プロフィール画面'
      end
    end

    context '未ログイン時' do
      before do
        visit edit_mypage_user_user_path user_a.id
      end

      it 'プロフィール画面に遷移出来ない' do
        expect(page).not_to have_content 'プロフィール画面'
      end
      it 'ログイン画面に遷移する' do
        expect(page).to have_content 'ログイン'
      end
    end
  end

  describe '別のユーザーのプロフィール画面に遷移できない' do
    let(:user_a) { create(:user, name: 'ユーザーA', email: 'a@g.com', uuid: 'uuid-a') }
    let(:user_b) { create(:user, name: 'ユーザーB', email: 'b@g.com', uuid: 'uuid-b') }

    context 'ユーザーAでログイン時' do
      before do
        login_user(user_a.email, 'password')
      end

      it 'ユーザーBのプロフィール画面に遷移出来ない' do
        visit edit_mypage_user_user_path user_b.id
        expect(page).not_to have_content 'プロフィール画面'
      end
    end
  end
end

# 未ログインでプロフィール画面に遷移できない
# 別のユーザーのプロフィール画面に遷移できない
# プロフィールが更新出来る
#
