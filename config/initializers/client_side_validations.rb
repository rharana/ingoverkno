# frozen_string_literal: true

# ClientSideValidations Initializer

# Uncomment and configure if you want to disable certain validators
# ClientSideValidations::Config.disabled_validators = []

# Uncomment to validate number format with the current I18n locale
# ClientSideValidations::Config.number_format_with_locale = true

# Example configuration for attaching validation messages directly to inputs
# ClientSideValidations Initializer

ActionView::Base.field_error_proc = proc do |html_tag, instance|
    if /^<label/.match?(html_tag)
      html_tag.html_safe
    else    
        error_message = instance.error_message.join('; ')
        # Render the HTML with the custom marker
        %(<div class="field_with_errors">#{html_tag}<span class="error_marker">#{error_message}</span></div>).html_safe
    end
  end