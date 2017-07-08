class Administrator < User
  include SearchWrapper

  searchkick

  def search_data
    {
      first_name: first_name,
      last_name: last_name,
      email: email,
      institution_id: institution_id,
    }
  end
end
