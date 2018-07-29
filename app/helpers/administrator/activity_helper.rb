module Administrator::ActivityHelper
  def get_version_user(version, users)
    users.select { |user| user.id == version.whodunnit.to_i }.first
  end

  def get_version_event_color_class(event)
    case event
      when 'create' then 'text-navy'
      when 'update' then 'text-lazur'
      when 'destroy' then 'text-danger'
      else 'text-yellow'
    end
  end

  def get_version_event_background_class(event)
    case event
      when 'create' then 'bg-success'
      when 'update' then 'bg-info'
      when 'destroy' then 'bg-danger'
      else 'bg-warning'
    end
  end

  def display_item_name(version)
    version.item_type.constantize.with_deleted.find_by(id: version.item_id).name
  end

  def display_version_description(details)
    return if details.blank?

    details.split("\n").reject do |part|
      blanklisted_attributes.any? do |attribute|
        part.include?(attribute)
      end
    end.join('<br>')
  end

  private
    def blanklisted_attributes
      %w(created_at updated_at deleted_at)
    end
end
