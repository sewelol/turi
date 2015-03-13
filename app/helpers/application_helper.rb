module ApplicationHelper

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

end
