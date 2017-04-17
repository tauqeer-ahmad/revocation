class SectionStudent < ApplicationRecord
  belongs_to :student
  belongs_to :section
  belongs_to :term
  belongs_to :klass
end
