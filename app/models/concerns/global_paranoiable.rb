module GlobalParanoiable
  extend ActiveSupport::Concern

  included do
    acts_as_paranoid

    def self.paranoia_scope
      where('deleted_in_term_id is null or deleted_in_term_id > ?', Current.term.id)
    end

    def self.with_deleted
      unscoped
    end

    def self.only_deleted
      unscoped.where('deleted_in_term_id is not null and deleted_in_term_id <= ?', Current.term.id)
    end

    def paranoia_restore_attributes
      {
        deleted_at: nil,
        deleted_in_term_id: nil
      }
    end

    def paranoia_destroy_attributes
      {
        deleted_at: current_time_from_proper_timezone,
        deleted_in_term_id: Current.term
      }
    end
  end
end
