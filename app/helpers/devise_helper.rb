# Declares several devise helpers.
module DeviseHelper

  # Returns the default application message layout.
  def devise_error_messages!

    # TODO: Can we simply use render 'layouts/_messages' ?

    return '' if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    html = <<-HTML
      <div class="alert alert-error alert-dismissable">
        <p>#{messages}</p>
      </div>
    HTML

    html.html_safe
  end

end