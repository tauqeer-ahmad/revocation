module SearchCallbackable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

      after_create :index_document
      after_destroy :update_document
      after_restore :update_document
      after_real_destroy :delete_document

      def index_document
        self.__elasticsearch__.index_document
      end

      def update_document
        self.__elasticsearch__.update_document
      end

      def delete_document
        self.__elasticsearch__.delete_document
      end
  end
end
