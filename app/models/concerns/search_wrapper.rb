module SearchWrapper
  extend ActiveSupport::Concern

  module ClassMethods
    def tenant_index_name
      -> { [Apartment::Tenant.current, model_name.plural, Rails.env].join('_') }
    end

    def lookup(keyword, clause = {})
      return all if keyword.blank? && clause.blank?
      self.search search_key(keyword), where: clause.merge!(paranoia_condition)
    end

    def paranoia_condition
      return {_or: [{deleted_at: nil}, {deleted_in_term_id: {gt: Current.term&.id}}]} if self.name.in?(PARANOIA_TERM_CONDITION_MODELS)
      return {deleted_at: nil}
    end

    def search_key(keyword)
      keyword.present? ? keyword : '*'
    end
  end
end
