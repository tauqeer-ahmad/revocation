class Teacher::SectionsController < ApplicationController
  before_action :check_current_term

  def index
    @section_subject_teachers = current_user.section_subject_teachers.includes(:subject, {section: :klass}).where(term_id: current_term.id)
    @assignment = current_term.assignments.build
  end

  private
    def check_current_term
      return redirect_to(root_path) unless current_term.present?
    end
end
