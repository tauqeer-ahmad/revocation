class Notice < ApplicationRecord
  belongs_to :klass
  belongs_to :section

  include SearchWrapper

  searchkick index_name: tenant_index_name, match: :word_start, searchable: [:title]

  TYPES = ['General', 'Teacher', 'Guardian', 'Class Specific', 'Section Specific']
  TEACHER_TYPES = ['General', 'Teacher', 'Class Specific', 'Section Specific']

  scope :latest, -> { where("created_at > ?", Time.now - 24.hours) }
  scope :of_klass, -> (klass_id) { where(klass_id: klass_id) }
  scope :of_section, -> (section_id) { where(section_id: section_id) }
  scope :ordered, -> { order(created_at: :desc) }
  scope :class_specific, -> { where(notice_type: 'Class Specific') }
  scope :for_teachers, -> { where(notice_type: TEACHER_TYPES) }
  scope :for_guardians, -> { where(notice_type: 'Guardian') }
  scope :for_all, -> { where(notice_type: 'General') }

  def search_data
    {
      title: title,
      message: message,
      klass_id: klass_id,
      section_id: section_id,
      notice_type: notice_type,
    }
  end

  def self.new_notice_count(user, term, type = nil)
    return self.latest.count if user.type_of == 'Administrator'
    return self.latest.for_teachers.count if user.type_of == 'Teacher'

    if user.type_of.in?(['Guardian', 'Student'])
      current_section = user.current_section(term.id)
      results = latest.of_klass(current_section.klass_id).class_specific.or(latest.of_klass(current_section.klass_id).of_section(current_section.id)).or(latest.for_all)

      type == 'Guardian' ? results.or(for_guardians).count : results.count
    end
  end

  def self.latest_notices(user, term, type = nil)
    return self.latest.ordered.first(5) if user.type_of == 'Administrator'
    return self.latest.for_teachers.ordered.first(5) if user.type_of == 'Teacher'

    if user.type_of.in?(['Guardian', 'Student'])
      current_section = user.current_section(term.id)
      results = self.latest.of_klass(current_section.klass_id).class_specific.or(latest.of_klass(current_section.klass_id).of_section(current_section.id)).or(latest.for_all)

      type == 'Guardian' ? results.or(latest.for_guardians).ordered.first(5) : results.ordered.first(5)
    end
  end
end
