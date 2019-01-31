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

  def default_meta_tags
    {
        site: Settings.common.app.name,
        reverse: true,
        title: Settings.common.app.page_title,
        description: Settings.common.app.page_description,
        keywords: Settings.common.app.page_keywords,
        canonical: request.original_url,
        separator: '|'
    }
  end
end
