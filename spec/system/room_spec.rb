require 'rails_helper'

describe 'チャット部屋画面', type: :system do
  include RoomsControllerModule

  describe '部屋への入室について' do
    let(:user_a) { create(:user, name: 'ユーザーA') }
    let(:user_b) { create(:user, name: 'ユーザーB') }

    before do
      create_owner_room user_a
    end

    context '入室条件を満たしている' do
      before do
        login_user(user_a.email, 'password')
      end

      it 'チャット部屋に入室出来る' do
        visit room_path user_a.uuid
        expect(page).to have_content 'メッセージ欄'
      end
    end

    context '入室条件を満たしていない' do
      before do
        login_user(user_b.email, 'password')
      end

      it 'チャット部屋に入室出来ない' do
        visit room_path user_a.uuid
        expect(page).not_to have_content 'メッセージ欄'
        expect(page).to have_content 'ホーム画面'
      end
    end
  end
end
