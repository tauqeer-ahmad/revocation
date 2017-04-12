class Teacher < User
  belongs_to :institution
  has_many :sections, :class_name => "Section", :foreign_key => "incharge_id"
end
