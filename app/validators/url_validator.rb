# This allows us to assign the validator in the model
module ActiveModel::Validations::HelperMethods
  def validates_url(*attr_names)
    validates_with UrlValidator, _merge_attributes(attr_names)
  end
end
class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || "must be a valid URL") unless url_valid?(value)
  end

  # a URL may be technically well-formed but may
  # not actually be valid, so this checks for both.
  def url_valid?(url)
    url = URI.parse(url) rescue false
    url.kind_of?(URI::HTTP) || url.kind_of?(URI::HTTPS)
  end
end
