class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def validate_attribute(attribute, value)
    attribute = attribute.to_sym
    self.class.validators_on(attribute).each do |validator|
      validator.validate_each(self, attribute, value)
    end
  end
end
