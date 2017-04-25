class AddSubdomainToInstitutions < ActiveRecord::Migration[5.0]
  def change
    add_column :institutions, :subdomain, :string, limit: 15
    add_index :institutions, :subdomain
  end
end
