namespace :searchkick do
  desc 'Reindex all models on all tenants'
  task reindex_tenants: :environment do
    Rails.application.eager_load!

    Apartment::Tenant.each do |schema|
      Apartment::Tenant.switch!(schema)
      SEARCHKICK_MODELS.each do |model|
        p "Reindexing #{model} on #{schema}"
        model.constantize.reindex
      end
    end
  end
end
