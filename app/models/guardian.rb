class Guardian < User
  include SearchWrapper
  include Authentication

  searchkick index_name: tenant_index_name, match: :word_start, searchable: [:first_name, :last_name, name: :exact]

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
      deleted_at: deleted_at,
      deleted_in_term_id: deleted_in_term_id,
      name: full_name,
    }
  end

  def search_name
    full_name
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def set_password
    @password = SecureRandom.hex(10)
    self.password = @password
  end

  def send_password
    begin
      GuardianMailer.send_password(self, Institution.current, @password).deliver!
    rescue
      logger.info "Password Email not sent for Guardian #{self.name}"
    end
  end
end
