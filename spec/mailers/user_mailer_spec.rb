require 'rails_helper'
require 'securerandom'

RSpec.describe UserMailer, type: :mailer do
  describe 'reset_password_email' do
    let (:user) { FactoryBot.create(:user, name: 'tester', email: 'test@g.com', reset_password_token: SecureRandom.uuid) }
    let (:mail) { UserMailer.reset_password_email(user) }

    it '宛先が正しいか' do
      expect(mail.subject).to eq('パスワードの再設定')
      expect(mail.to).to eq(['test@g.com'])
      expect(mail.from).to eq(['noreply@tsunagaru.space'])
    end

    it '内容が正しいか' do
      html_part = mail.body.parts.find{ |p| p.content_type.match('html') }
      expect(html_part.body.raw_source).to match('パスワードの再設定を行います。')

      text_part = mail.body.parts.find{ |p| p.content_type.match('plain') }
      expect(text_part.body.raw_source).to match('パスワードの再設定を行います。')

      link = edit_password_reset_url(user.reset_password_token)
      expect(html_part.body).to match(link)
    end
  end
end
