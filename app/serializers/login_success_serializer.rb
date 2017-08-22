class LoginSuccessSerializer < ActiveModel::Serializer
  attributes :name, :email, :access_token, :category, :subdomain, :institution, :avatar_url, :thumb_avatar_url, :medium_avatar_url

  def subdomain
    instance_options[:subdomain]
  end

  def institution
    instance_options[:institution]
  end

  def medium_avatar_url
    object.avatar.url(:medium)
  end

  def thumb_avatar_url
    object.avatar.url(:thumb)
  end

  def avatar_url
    object.avatar.url
  end
end
