require 'rails_helper'

describe 'プロフィール画面', type: :system do
  describe 'ログイン・未ログインの画面遷移' do
    let(:user_a) { create(:user, name: 'ユーザーA', email: 'a@g.com') }

    context 'ログイン時' do
      before do
        login_user(user_a.email, 'password')
      end

      it 'プロフィール画面に遷移出来る' do
        visit mypage_user_path
        expect(page).to have_content 'プロフィール画面'
      end
    end

    context '未ログイン時' do
      before do
        visit mypage_user_path
      end

      it 'プロフィール画面に遷移出来ない' do
        expect(page).not_to have_content 'プロフィール画面'
      end
      it 'ログイン画面に遷移する' do
        expect(page).to have_content 'ログイン'
      end
    end
  end

  describe 'プロフィールの更新' do
    let(:user_a) { create(:user,
                          name: 'ユーザーA',
                          email: 'a@g.com',
                          image: Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/avatar_sample.png'), 'image/jpeg') ) }

    before do
      login_user(user_a.email, 'password')
    end

    describe 'メールアドレスの更新' do
      before do
        visit mypage_user_path
        fill_in 'user_email', with: 'a2@g.com'
        click_button '更新'
      end

      it 'メールアドレスが更新出来る' do
        expect(page).to have_field 'user_email', with: 'a2@g.com'
      end
      it '正しくリダイレクトされる' do
        expect(current_path).to eq mypage_user_path
      end
    end

    describe '自己紹介文の更新' do
      before do
        visit mypage_user_path
        fill_in 'user_introduction', with: '私はユーザーAです'
        click_button '更新'
      end

      it '自己紹介文が更新出来る' do
        expect(page).to have_field 'user_introduction', with: '私はユーザーAです'
      end
      it '正しくリダイレクトされる' do
        expect(current_path).to eq mypage_user_path
      end
    end

    describe 'アバター画像の更新' do
      before do
        visit mypage_user_path
        # attach_file '#user_image', "#{Rails.root}/spec/images/logo.png", {display: 'block'}
        # attach_file('user[image]', "#{Rails.root}/spec/images/logo.png", make_visible: true)
        user_a.image = Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/logo.png'), 'image/jpeg')
        click_button '更新'
      end

      it 'アバター画像が更新出来る' do
        expect(user_a.image.url.split('/').last).to eq 'logo.png'
        expect(page).to have_content 'プロフィールを更新しました'
      end
      it '正しくリダイレクトされる' do
        expect(current_path).to eq mypage_user_path
      end
    end
  end
end
