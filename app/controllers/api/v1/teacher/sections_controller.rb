class Api::V1::Teacher::SectionsController < Api::V1::Teacher::TeacherBaseController
  def index
    @sections = current_user.section_subject_teachers.of_term(current_term.id).includes(:subject, section: :klass)
    render json: @sections, root: :sections
  end
end
