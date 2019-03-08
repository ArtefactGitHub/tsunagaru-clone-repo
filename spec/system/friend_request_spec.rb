require 'rails_helper'

# page.save_screenshot
# take_full_page_screenshot

describe 'トモダチ申請画面', type: :system do
  let(:user_a) { create(:user, name: 'ユーザーA') }
  let(:user_b) { create(:user, name: 'ユーザーB') }

  describe 'トモダチ申請について' do
    before do
      login_user(user_a.email, 'password')
      visit mypage_friend_requests_path
    end

    it 'トモダチ申請画面に遷移出来る' do
      expect(page).to have_content 'トモダチ申請'
      expect(page).to have_selector '.text-friend_request'
    end

    context '正しい値で申請を行う場合' do
      before do
        fill_in 'friend_request_uuid', with: user_b.uuid
        click_button '申請'
      end

      context '片側から申請した場合' do
        it '申請中/受理中になる' do
          expect(page).to have_content 'トモダチ申請を行いました'
          expect(page).to have_content "#{user_b.name}さんに\nトモダチ申請中です"

          # ユーザーBでログインする
          login_user(user_b.email, 'password')
          visit mypage_friend_requests_path
          expect(page).to have_content "#{user_a.name}さんから\nトモダチ申請を受けています"
        end
      end

      context '相互に申請した場合' do
        before do
          # ユーザーBでログインする
          login_user(user_b.email, 'password')
          visit mypage_friend_requests_path
          fill_in 'friend_request_uuid', with: user_a.uuid
          click_button '申請'
        end

        it '承認済みになる' do
          expect(page).to have_content 'トモダチ申請が承認されました'
          expect(page).to have_content '申請がありません'
          expect(page).not_to have_content "#{user_a.name}さんから\nトモダチ申請を受けています"

          visit mypage_friend_friends_path
          expect(page).to have_content 'トモダチ帳'
          expect(page).to have_content user_a.uuid

          visit mypage_root_path
          expect(page).to have_content user_a.name

          # ユーザーAでログインし、ユーザーBがトモダチになった表示を確認する
          login_user(user_a.email, 'password')
          expect(page).to have_content user_b.name
          visit mypage_friend_friends_path
          expect(page).to have_content user_b.uuid
        end
      end

      context '受理中の申請を承認した場合' do
        before do
          # ユーザーBでログインする
          login_user(user_b.email, 'password')
          visit mypage_friend_requests_path
          expect(page).to have_content "#{user_a.name}さんから\nトモダチ申請を受けています"
          click_button 'はい'
        end

        it '承認済みになる' do
          expect(page).to have_content 'トモダチ申請が承認されました'
          expect(page).to have_content '申請がありません'
          expect(page).not_to have_content "#{user_a.name}さんから\nトモダチ申請を受けています"

          visit mypage_friend_friends_path
          expect(page).to have_content 'トモダチ帳'
          expect(page).to have_content user_a.uuid

          visit mypage_root_path
          expect(page).to have_content user_a.name

          # ユーザーAでログインし、ユーザーBがトモダチになった表示を確認する
          login_user(user_a.email, 'password')
          expect(page).to have_content user_b.name
          visit mypage_friend_friends_path
          expect(page).to have_content user_b.uuid
        end
      end
    end

    context '間違った値で申請を行う場合' do
      context '空で申請した場合' do
        it '申請が行われない（required のためPOSTが行えない）' do
          fill_in 'friend_request_uuid', with: ''
          click_button '申請'
          expect(page).not_to have_content 'トモダチ申請を行いました'
        end
      end

      context '間違ったUUIDで申請した場合' do
        it '申請相手が見つからない表示になる' do
          fill_in 'friend_request_uuid', with: 'hogehoge'
          click_button '申請'
          expect(page).to have_content '申請相手が見つかりません'
        end
      end
    end
  end
end
