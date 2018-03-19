class InFutureValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    return true unless value.present? && object.start_date.present?

    comparison = options[:comparison]
    if comparison == :lte && value >= object.send(options[:after_or_equal_to])
      object.errors.add attribute,
      (options[:message] || "cannot be before the #{options[:after_or_equal_to].to_s.humanize.downcase}")
    elsif comparison == :gte && value <= object.send(options[:after_or_equal_to])
      object.errors.add attribute,
      (options[:message] || "cannot be after the #{options[:after_or_equal_to].to_s.humanize.downcase}")
     elsif comparison == :equal && value == object.send(options[:after_or_equal_to])
      object.errors.add attribute,
      (options[:message] || "should be equal to #{options[:after_or_equal_to].to_s.humanize.downcase}")
    end
  end
end


module ActiveModel::Validations::HelperMethods
  def in_future(*attr_names)
    p attr_names
    validates_with InFutureValidator, _merge_attributes(attr_names)
  end
end
