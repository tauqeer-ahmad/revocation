module SearchWrapper
  extend ActiveSupport::Concern

  module ClassMethods
    def tenant_index_name
      -> { [Apartment::Tenant.current, model_name.plural, Rails.env].join('_') }
    end

    def lookup(keyword, clause = {})
      return all unless keyword.present?
      self.search keyword, where: clause
    end
  end
end
