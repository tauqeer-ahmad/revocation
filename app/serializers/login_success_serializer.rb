class LoginSuccessSerializer < ActiveModel::Serializer
  attributes :name, :email, :access_token, :category, :subdomain, :institution

  def subdomain
    instance_options[:subdomain]
  end

  def institution
    instance_options[:institution]
  end
end
