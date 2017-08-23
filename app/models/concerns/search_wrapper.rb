module SearchWrapper
  extend ActiveSupport::Concern

  module ClassMethods
    def tenant_index_name
      -> { [Apartment::Tenant.current, model_name.plural, Rails.env].join('_') }
    end

    def lookup(keyword, clause = {})
      return all if keyword.blank? && clause.blank?

      self.search search_key(keyword), where: clause
    end

    def search_key(keyword)
      keyword.present? ? keyword : '*'
    end
  end
end
