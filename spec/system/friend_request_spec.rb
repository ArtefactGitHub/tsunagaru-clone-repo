require 'rails_helper'

# page.save_screenshot

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
