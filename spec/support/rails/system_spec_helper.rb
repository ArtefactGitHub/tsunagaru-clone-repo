module TestHelpers
  module Rails
    module Systems
      def login_user(email, password)
        visit login_url

        fill_in 'email',    with: email
        fill_in 'password', with: password

        click_button 'ログイン'
      end
    end
  end
end
