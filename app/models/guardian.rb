class Guardian < User
  has_many :children, class_name: 'Student', foreign_key: 'guardian_id'
end
