module SearchWrapper
  extend ActiveSupport::Concern

  module ClassMethods
    def tenant_index_name
      -> { [Apartment::Tenant.current, model_name.plural, Rails.env].join('_') }
    end

    def lookup(keyword, options={where: {}})
      return all if keyword.blank? && options.blank?
      options[:where] = {} if options[:where].blank?
      options[:where].merge!(paranoia_condition)
      self.search search_key(keyword), options
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
