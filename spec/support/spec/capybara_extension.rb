module TestHelpers
  module Spec
    module Capybara_Extension
      def take_full_page_screenshot(path)
        width  = Capybara.page.execute_script("return Math.max(document.body.scrollWidth, document.body.offsetWidth, document.documentElement.clientWidth, document.documentElement.scrollWidth, document.documentElement.offsetWidth);")
        height = Capybara.page.execute_script("return Math.max(document.body.scrollHeight, document.body.offsetHeight, document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight);")

        window = Capybara.current_session.driver.browser.manage.window
        window.resize_to(width+100, height+100)

        page.save_screenshot path
      end
    end
  end
end
