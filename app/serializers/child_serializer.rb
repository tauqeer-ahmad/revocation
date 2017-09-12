class ChildSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :klass_name, :section_name, :avatar_url, :thumb_avatar_url, :medium_avatar_url

  def current_term
    @current_term ||= Term.active_term
  end

  def klass_name
    object.current_section(current_term.id).klass.name
  end

  def section_name
    object.current_section(current_term.id).name
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
