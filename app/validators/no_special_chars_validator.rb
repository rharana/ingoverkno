# app/validators/no_special_chars_validator.rb
class NoSpecialCharsValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      if value.match?(/[^A-Za-z0-9]/)
        record.errors.add(attribute, (options[:message] || 'Only letters and numbers'))
      end
    end
end