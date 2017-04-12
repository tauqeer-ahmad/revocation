class Section < ApplicationRecord
  belongs_to :institution
  belongs_to :term
  belongs_to :klass
  belongs_to :incharge, :class_name => "Teacher", :foreign_key => "incharge_id"
  
  def incharge_name
    incharge.name
  end
end
