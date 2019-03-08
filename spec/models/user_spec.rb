require 'rails_helper'

RSpec.describe User, type: :model do
  include RoomsControllerModule

  let(:user) { FactoryBot.create(:user) }

  required_params = { name: 'hoge', uuid: 'uuid-hoge', email: 'hoge@g.com', password: 'password', password_confirmation: 'password' }

  describe 'バリデーション' do
    describe 'ユーザーインスタンスの生成について' do
      context '必須となる属性を満たしている' do
        it 'バリデーションが通る' do
          target = User.new(name: 'hoge',
                            uuid: 'uuid',
                            email: 'hoge@g.com',
                            password: 'password',
                            password_confirmation: 'password')
          expect(target).to be_valid
        end
      end

      context '必須となる属性を満たしていない' do
        it 'バリデーションが通らない' do
          required_params = {name: 'hoge', uuid: 'uuid', email: 'hoge@g.com', password: 'password', password_confirmation: 'password'}
          not_have_name = User.new(required_params.merge(name: nil))
          not_have_uuid = User.new(required_params.merge(uuid: nil))
          not_have_email = User.new(required_params.merge(email: nil))
          not_have_password = User.new(required_params.merge(password: nil))
          not_have_password_confirmation = User.new(required_params.merge(password_confirmation: nil))
          expect(not_have_name).not_to be_valid
          expect(not_have_uuid).not_to be_valid
          expect(not_have_email).not_to be_valid
          expect(not_have_password).not_to be_valid
          expect(not_have_password_confirmation).not_to be_valid
        end
      end
    end

    describe '名前の文字列長について' do
      context '最大20文字を満たしている' do
        it 'バリデーションが通る' do
          target = User.new(required_params.merge(name: 'a' * 20))
          expect(target).to be_valid
        end
      end

      context '最大20文字を満たしていない' do
        it 'バリデーションが通らない' do
          target = User.new(required_params.merge(name: 'a' * 21))
          expect(target).not_to be_valid
        end
      end
    end

    describe '自己紹介の文字列長について' do
      context '最大999文字を満たしている' do
        it 'バリデーションが通る' do
          target = User.new(required_params.merge(introduction: 'a' * 999))
          expect(target).to be_valid
        end
      end

      context '最大999文字を満たしていない' do
        it 'バリデーションが通らない' do
          target = User.new(required_params.merge(introduction: 'a' * 1000))
          expect(target).not_to be_valid
        end
      end
    end

    describe 'メールアドレスの一意性について' do
      context '一意ではない' do
        let(:user_a) { FactoryBot.create(:user, name: 'user_a', email: 'hoge@g.com') }

        it 'バリデーションが通らない' do
          user_b = User.new(required_params.merge(email: user_a.email))
          expect(user_b).not_to be_valid
        end
      end
    end

    describe 'パスワードについて' do
      describe 'パスワードの文字列長について' do
        context '最低6文字以上を満たしていない' do
          it 'バリデーションが通らない' do
            target = User.new(required_params.merge(password: 'a'))
            expect(target).not_to be_valid
          end
        end
      end

      describe '確認用パスワードについて' do
        context 'パスワードと確認用パスワードが異なっている' do
          it 'バリデーションが通らない' do
            target = User.new(required_params.merge(password: 'hogehoge',
                                                    password_confirmation: 'fugafuga'))
            expect(target).not_to be_valid
          end
        end
      end
    end
  end

  describe 'スコープについて' do
    let(:user_a) { FactoryBot.create(:user, name: 'user_a') }
    let(:user_b) { FactoryBot.create(:user, name: 'user_b') }

    before do
      # ユーザーAとユーザーBをトモダチにしておく
      req_from_a = user_a.send_requests.build(receiver: user_b)
      req_from_b = user_b.send_requests.build(receiver: user_a)
      req_from_a.update_approval!
      req_from_b.update_approval!
    end

    describe 'トモダチの取得について' do
      it 'ユーザーAのトモダチとしてユーザーBが取得出来る' do
        friend = User.friends_of user_a
        expect(friend).to include user_b
      end
    end

    describe 'チャット部屋のユーザーの絞り込みについて' do
      let(:user_c) { FactoryBot.create(:user, name: 'user_c') }

      before do
        create_owner_room user_b
      end

      it 'ユーザーBのチャット部屋のユーザーが正しく取得出来る' do
        members = User.room_members_of user_b.my_room
        expect(members).to include user_a
        expect(members).to include user_b
        expect(members).not_to include user_c
      end
    end
  end

  describe 'メソッドについて' do
    describe 'avatar_or_default' do
      it 'アバターが設定されていない場合に、デフォルト画像が取得出来る' do
        image = user.avatar_or_default
        expect(image).to eq Settings.user.avatar.default_file_name
      end
    end

    describe 'set_uuid' do
      it 'UUID の中に、19q0ioOIlなどのそれぞれ似ている文字を除いて生成出来る' do
        100.times do
          uuid = user.set_uuid
          expect(uuid).not_to include Settings.user.uuid_urlsafe_base64_except
        end
      end
    end

    describe 'can_access_room' do
      let(:user_a) { FactoryBot.create(:user, name: 'user_a') }
      let(:user_b) { FactoryBot.create(:user, name: 'user_b') }
      let(:user_c) { FactoryBot.create(:user, name: 'user_c') }

      before do
        # ユーザーAとユーザーBをトモダチにしておく
        req_from_a = user_a.send_requests.build(receiver: user_b)
        req_from_b = user_b.send_requests.build(receiver: user_a)
        req_from_a.update_approval!
        req_from_b.update_approval!

        create_owner_room user_b
      end

      context '部屋の入室条件を満たしている' do
        it '結果が真となる' do
          expect(user_a.can_access_room?(user_b.my_room)).to be_truthy
          expect(user_b.can_access_room?(user_b.my_room)).to be_truthy
        end
      end

      context '部屋の入室条件を満たしていない' do
        it '結果が偽となる' do
          expect(user_c.can_access_room?(user_b.my_room)).to be_falsey
        end
      end
    end

    describe 'can_post_to_operation' do
      context 'お問い合わせの送信間隔が十分である' do
        it '結果が真となる' do
          user.post_to_operation_sent_at = Time.current - Settings.user.post_to_operation_interval - 100
          expect(user.can_post_to_operation?).to be_truthy
        end
      end

      context 'お問い合わせの送信間隔が十分でない' do
        it '結果が偽となる' do
          user.post_to_operation_sent_at = Time.current
          expect(user.can_post_to_operation?).to be_falsey
        end
      end
    end

    describe 'assign_password' do
      it 'パスワードと確認用パスワードが一致したものが生成される' do
        100.times do
          user.assign_password
          expect(user.password).to eq user.password_confirmation
        end
      end
    end
  end
end
