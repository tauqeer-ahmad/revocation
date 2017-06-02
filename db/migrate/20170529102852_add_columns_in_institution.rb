class AddColumnsInInstitution < ActiveRecord::Migration[5.0]
  def change
    add_attachment :institutions, :logo
    add_column :institutions, :email, :string, limit: 60
    add_column :institutions, :phone_number, :string, limit: 60
    add_column :institutions, :fax_number, :string, limit: 60
    add_column :institutions, :address, :string, limit: 100
    add_column :institutions, :contact_description, :string, limit: 150
    add_column :institutions, :facebook_url, :string, limit: 100
    add_column :institutions, :twitter_url, :string, limit: 100
    add_column :institutions, :linkedin_url, :string, limit: 100
    add_column :institutions, :video_url, :string, limit: 100
  end
end
