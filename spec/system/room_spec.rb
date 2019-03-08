require 'rails_helper'

describe 'チャット部屋画面', type: :system do
  include RoomsControllerModule

  let(:user_a) { create(:user, name: 'ユーザーA') }

  context '部屋への入室前' do
    before do
      create_owner_room user_a
      login_user(user_a.email, 'password')
    end

    describe '入室処理について' do
      context '入室条件を満たしている' do
        it 'チャット部屋に入室出来る' do
          visit room_path user_a.uuid
          expect(page).to have_content 'メッセージ欄'
        end
      end

      context '入室条件を満たしていない' do
        let(:user_b) { create(:user, name: 'ユーザーB') }
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

    describe '利用タイプ毎の表示の切り替えについて' do
      context '「チャットのみ」の場合' do
        before do
          setting = user_a.use_type_setting
          setting.update_column(:use_type, :only_chat)
          setting.setup_optional
          setting.save!
        end

        it 'メッセージボタンが表示され、テキスト入力が表示されない' do
          visit room_path user_a.uuid
          expect(page).to have_selector('#button-message-section')
          expect(page).not_to have_selector('#text-message-section')
        end
      end

      context '「いろいろ」の場合' do
        before do
          setting = user_a.use_type_setting
          setting.update_column(:use_type, :use_normal)
          setting.setup_optional
          setting.save!
        end

        it 'テキスト入力が表示され、メッセージボタンが表示されない' do
          visit room_path user_a.uuid
          expect(page).to have_selector('#text-message-section')
          expect(page).not_to have_selector('#button-message-section')
        end
      end
    end

    describe 'トモダチ解除について' do
      let(:user_b) { create(:user, name: 'ユーザーB') }

      before do
        # ユーザーAとユーザーBをトモダチにしておく
        req_from_a = user_a.send_requests.build(receiver: user_b)
        req_from_b = user_b.send_requests.build(receiver: user_a)
        req_from_a.update_approval!
        req_from_b.update_approval!

        # ユーザーBでログインし、トモダチのユーザーAの部屋に入る
        login_user(user_b.email, 'password')
        visit room_path user_a.uuid

        # トモダチ解除
        user_a.send_requests.first.destroy!
        user_b.send_requests.first.destroy!
      end

      it 'リロードするとホーム画面に戻される' do
        visit current_path
        expect(page).not_to have_content 'メッセージ欄'
        expect(page).to have_content 'ホーム画面'
      end

      # it '' do
      #   Message.system_to_room(I18n.t('rooms.notify_reject_friends'), user_a.my_room)
      #   sleep 2
      #   Message.create!(content: '解除後のメッセージ', user: user_b, room: user_a.my_room)
      #   expect(page).not_to have_content '解除後のメッセージ'
      # end
    end
  end

  context '部屋への入室後' do
    before do
      create_owner_room user_a
      login_user(user_a.email, 'password')
      visit room_path user_a.uuid
    end

    describe '部屋の属性について' do
      context 'data-current_user_uuid属性の場合' do
        subject { find('#js-connect-room')['data-current_user_uuid'] }
        it { is_expected.to eq user_a.uuid }
      end

      context 'data-use_type属性の場合' do
        subject { find('#js-connect-room')['data-use_type'] }
        it { is_expected.to eq user_a.get_use_type }
      end
    end
  end
end
