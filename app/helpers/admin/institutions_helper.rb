module Admin::InstitutionsHelper
  def get_institution_status_class(status)
    case status
    when 'pending'
      'label-warning'
    when 'active'
      'label-primary'
    when 'locked'
      'label-danger'
    end
  end

  def get_institution_sector_class(sector)
    case sector.downcase
    when 'public'
      'label-primary'
    when 'private'
      'label-warning'
    end
  end
end
