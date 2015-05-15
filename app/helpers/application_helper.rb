module ApplicationHelper

  def page_title(title)
    content_for :page_title do
      title
    end
  end

  def page_title_t(title)
    page_title t(title)
  end

  def form_group_class(record, attribute)
    error_class = record.errors.include?(attribute) ? 'has-error' : ''
    return "form-group #{error_class}"
  end

  def form_group_errors(record, attribute)
    errors = ''
    record.errors.full_messages_for(attribute).each do |m|
      errors = errors << "<span class=\"help-block\">#{m}</span>"
    end
    return errors.html_safe
  end

  def formatted_data_time(date_time)
    return date_time.strftime(I18n.t('date_time'))
  end

  def quote(message)
    render 'layouts/quote', :message => message
  end

  def quote_btn(message, link_title, link, link_id)
    render 'layouts/quote_btn', :message => message, :link_title => link_title, :link => link, :link_id => link_id
  end

  def quote_t(message)
    quote t(message)
  end

end
