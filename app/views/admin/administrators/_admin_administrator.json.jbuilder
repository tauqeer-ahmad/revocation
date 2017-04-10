json.extract! admin_administrator, :id, :first_name, last_name, :email, :password, :created_at, :updated_at
json.url admin_administrator_url(admin_administrator, format: :json)
