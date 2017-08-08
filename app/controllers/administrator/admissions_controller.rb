class Administrator::AdmissionsController < ApplicationController
  def index
    @klasses = Klass.all
  end

  def new
    @is_bulk = params[:type]
    @klass = Klass.find(params[:klass_id])
    @section = @klass.sections.find(params[:section_id])

    return redirect_to(bulk_view_administrator_section_students_path(@section)) if @is_bulk.present?
    redirect_to new_administrator_section_student_path(@section)
  end
end
