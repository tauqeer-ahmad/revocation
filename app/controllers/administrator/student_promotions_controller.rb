class Administrator::StudentPromotionsController < ApplicationController
  def index
    @initialized_term = Term.initialized.first
    return redirect_to(administrator_terms_path, alert: "Please create a new initialized term ") if @initialized_term.blank?
    return redirect_to(administrator_terms_path, alert: "Please switch to Active term to perfom promotions") unless current_term.active?
  end

  def list_students
    @section = current_term.sections.where(id: params[:section_id]).first
    @promotion_term = Term.initialized.first
    @promotion_section = @promotion_term.sections.find(params[:promotion_section_id])
    @students = @section.students.promotable
  end

  def create
    return redirect_to(administrator_student_promotions_path, alert: "Please select students for enrollment.") if params[:students].blank?
    student_ids = params[:students].map {|s| s["student_id"]}.collect(&:to_i)
    @section = current_term.sections.where(id: params[:section_id]).first
    @promotion_term = Term.initialized.first
    @promotion_section = @promotion_term.sections.find(params[:promotion_section_id])
    @students_sections = @section.section_students.promotable_students(student_ids)
    @student_mapping = @students_sections.pluck(:student_id, :roll_number).to_h
    ActiveRecord::Base.transaction do
      SectionStudent.create(student_section_params)
      @students_sections.update(promoted: true)
    end
    redirect_to administrator_student_promotions_path(klass_id: @section.klass_id, section_id: @section.id, promotion_klass_id: @promotion_section.klass_id, promotion_section_id: @promotion_section.id ), notice: "Selected students has successfull enrolled in section #{@promotion_section.name}"
  end

  private
   def student_section_params
      params.permit(students: [:student_id]).tap do |custom_params|
        custom_params[:students].each do |student|
          student[:term_id] = @promotion_term.id
          student[:section_id] = @promotion_section.id
          student[:klass_id] = @promotion_section.klass.id
          student[:roll_number] =@student_mapping[student[:student_id].to_i]
        end
      end[:students]
    end
end
