class LoginSuccessSerializer < ActiveModel::Serializer
  attributes :name, :email, :access_token, :category, :subdomain

  def subdomain
    instance_options[:subdomain]
  end
end
