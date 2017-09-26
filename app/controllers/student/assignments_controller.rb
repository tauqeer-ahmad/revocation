class Student::AssignmentsController < ApplicationController
  before_action :validate_section, only: [:index]
  before_action :set_assignment, only: :show

  def index
    @assignments = Assignment.of_section(params[:section_id]).includes(:subject, section: :klass).active.ordered
  end

  def show
  end

  private

    def validate_section
      @section = Section.find(params[:section_id])
      @klass = @section.klass

      redirect_to root_path, error: 'Invalid Access.' unless params[:section_id].to_i == selected_user.current_section(current_term.id).id
    end

    def set_assignment
      @assignment = Assignment.active.find(params[:id])

      redirect_to root_path, error: 'Invalid Access.' unless @assignment.section_id == selected_user.current_section(current_term.id).id
    end
end
