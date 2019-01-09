module ApplicationHelper
  def simple_time(time)
    time.strftime("%m/%d %H:%M")
  end

  def logged_in?
    current_user.present?
  end
end
