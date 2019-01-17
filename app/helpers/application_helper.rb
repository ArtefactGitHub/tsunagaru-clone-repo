module ApplicationHelper
  def simple_time(time)
    time.strftime("%m/%d %H:%M")
  end

  def escape_with_linefeed(text)
    simple_format(h(text))
  end

  def logged_in?
    current_user.present?
  end
end
