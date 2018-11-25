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

    attributes_list = details.split("\n").reject do |part|
      blacklisted_attributes.any? do |attribute|
        part.include?(attribute)
      end
    end

    content_tag(:ul) do
      attributes_list.each do |attribute|
        name_and_value = attribute.split(':')
        name = name_and_value.first
        value = name_and_value.last.gsub('"', '')

        concat(content_tag(:li) do
          "<strong>#{name}: </strong> #{value}".html_safe
        end)
      end
    end
  end

  def blacklisted_attributes
    %w(id updated_at created_at deleted_at ---)
  end
end
