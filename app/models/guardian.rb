class Guardian < User
  include SearchWrapper
  include Authentication

  searchkick index_name: tenant_index_name

  has_many :children, class_name: 'Student', foreign_key: 'guardian_id'

  before_validation :set_password, if: Proc.new { !self.encrypted_password? }
  after_create :send_password

  def search_data
    {
      first_name: first_name,
      last_name: last_name,
      email: email,
      profession: profession,
      cnic: cnic,
    }
  end

  def set_password
    @password = SecureRandom.hex(10)
    self.password = @password
  end

  def send_password
    GuardianMailer.send_password(self, Institution.current, @password).deliver!
  end
end
