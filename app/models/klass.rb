class Klass < ApplicationRecord
  include SearchWrapper

  searchkick index_name: tenant_index_name

  belongs_to :institution
  has_many :sections

  validates :name, presence: { message: 'Class name is required' }
  validates :code, presence: { message: 'Class code is required' }

  def search_data
    {
      name: name,
      code: code,
    }
  end
end
