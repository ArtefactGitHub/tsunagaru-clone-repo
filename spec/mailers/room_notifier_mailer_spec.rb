require 'rails_helper'
require 'securerandom'

RSpec.describe RoomNotifierMailer, type: :mailer do
  describe 'notify_new_message' do
    let (:message) { FactoryBot.create(:message) }
    let (:receiver) { FactoryBot.create(:user, name: 'receiver', email: 'receiver@g.com') }
    let (:mail) { RoomNotifierMailer.notify_new_message(message, receiver) }

    it '宛先が正しいか' do
      expect(mail.subject).to eq('新しいメッセージがあります')
      expect(mail.to).to eq(['receiver@g.com'])
      expect(mail.from).to eq(['noreply@tsunagaru.space'])
    end

    it '内容が正しいか' do
      content = "下記のチャット部屋に、#{message.user.name}さんから新しいメッセージがあります。"

      html_part = mail.body.parts.find{ |p| p.content_type.match('html') }
      expect(html_part.body.raw_source).to match(content)

      text_part = mail.body.parts.find{ |p| p.content_type.match('plain') }
      expect(text_part.body.raw_source).to match(content)

      link = room_url(message.room.owner.uuid)
      expect(html_part.body).to match(link)
    end
  end
end
