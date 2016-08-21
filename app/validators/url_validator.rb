class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    valid = begin
      uri = URI.parse(value)
      uri.kind_of?(URI::HTTP) && uri.host.present?
    rescue URI::InvalidURIError
      false
    end
    unless valid
      record.errors[attribute] << (options[:message] || "is an invalid URL")
    end
  end
end
