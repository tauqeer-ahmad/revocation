class Administrator < User
  include SearchWrapper

  searchkick

  def search_data
    {
      first_name: first_name,
      last_name: last_name,
      email: email,
      deleted_at: deleted_at,
      deleted_in_term_id: deleted_in_term_id,
      name: full_name,
    }
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
