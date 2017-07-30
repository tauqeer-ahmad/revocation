class Notice < ApplicationRecord
  belongs_to :klass
  belongs_to :section

  include SearchWrapper

  searchkick index_name: tenant_index_name, match: :word_start, searchable: [:title]

  TYPES = ['General', 'Class Specific', 'Section Specific']

  def search_data
    {
      title: title,
      message: message,
      notice_type: notice_type,
    }
  end
end
