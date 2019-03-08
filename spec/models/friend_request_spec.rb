require 'rails_helper'

RSpec.describe FriendRequest, type: :model do
  let(:user_a) { create(:user, name: 'ユーザーA') }
  let(:user_b) { create(:user, name: 'ユーザーB') }

  describe 'バリデーション' do
    describe 'インスタンスの生成について' do
      context '必須となる属性を満たしている' do
        it 'バリデーションが通る' do
          target = FriendRequest.new(sender: user_a, receiver: user_b)
          expect(target).to be_valid
        end
      end

      context '必須となる属性を満たしていない' do
        it 'バリデーションが通らない' do
          target = FriendRequest.new(sender: user_a)
          expect(target).not_to be_valid
        end
      end
    end

    describe '重複した申請について' do
      before do
        user_a.send_requests.create(receiver: user_b)
      end
      subject { user_a.send_requests.build(receiver: user_b) }
      it { is_expected.not_to be_valid }
    end

    describe '自分自身への申請について' do
      subject { user_a.send_requests.build(receiver: user_a) }
      it { is_expected.not_to be_valid }
    end

    describe 'トモダチの上限について' do
      before do
        Settings.room.limit_of_entry.times do |i|
          FriendRequest.create!(sender: user_a, receiver: create(:user), friend_request_status: :approval)
        end
      end
      subject { user_a.send_requests.build(receiver: user_b) }
      it { is_expected.not_to be_valid }
    end
  end

  describe 'スコープについて' do
    let(:user_c) { create(:user, name: 'ユーザーC') }

    before do
      # 承認済み
      @approval_from_a_to_b = user_a.send_requests.create(receiver: user_b)
      @approval_from_b_to_a = user_b.send_requests.create(receiver: user_a)
      @approval_from_a_to_b.update_approval!
      @approval_from_b_to_a.update_approval!
      # 申請中
      @request_from_b_to_c = user_b.send_requests.create(receiver: user_c, friend_request_status: :request)
      @request_from_c_to_a = user_c.send_requests.create(receiver: user_a, friend_request_status: :request)
    end

    describe '申請中・受理中の申請の絞り込み（承認済みは除く）' do
      subject { FriendRequest.sending_receiving user_a }
      it { is_expected.to include @request_from_c_to_a }
      it { is_expected.not_to include @request_from_b_to_c }
      it { is_expected.not_to include @approval_from_a_to_b }
      it { is_expected.not_to include @approval_from_b_to_a }
    end

    describe 'ユーザーAへの申請の絞り込み' do
      context '承認済みの場合' do
        subject { FriendRequest.receiving_from(user_a, user_b) }
        it { is_expected.not_to include @approval_from_b_to_a}
      end

      context '承認済みではない場合' do
        subject { FriendRequest.receiving_from(user_a, user_c) }
        it { is_expected.to include @request_from_c_to_a }
      end
    end

    describe '全ての承認済みの絞り込み' do
      subject { FriendRequest.approvals user_a }
      it { is_expected.to include @approval_from_a_to_b }
      it { is_expected.not_to include @request_from_b_to_a }
    end

    describe 'ユーザーAとユーザーB間の全ての申請の絞り込み' do
      subject { FriendRequest.pair_bidirectional(user_a, user_b) }
      it { is_expected.to include @approval_from_a_to_b }
      it { is_expected.to include @approval_from_b_to_a }
    end
  end
end
