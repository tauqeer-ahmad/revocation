json.extract! admin_institution, :id, :name, :location, :latitude, :longitude, :city, :country, :description, :sector, :level, :created_at, :updated_at
json.url admin_institution_url(admin_institution, format: :json)
