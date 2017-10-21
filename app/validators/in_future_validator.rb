class InFutureValidator < ActiveModel::EachValidator
 def validate_each(object, attribute, value)
   return true unless value.present? && object.start_date.present?
   if value <= object.send(options[:after_or_equal_to])
      object.errors.add attribute,
      (options[:message] || "cannot be before the start date")
    end
   end
end


module ActiveModel::Validations::HelperMethods
  def validates_email(*attr_names)
    validates_with InFutureValidator, _merge_attributes(attr_names)
  end
end
