class Administrator::SectionsController < ApplicationController
  before_action :check_current_term
  before_action :set_klass, except: [:index]
  before_action :set_section, only: [:show, :edit, :update, :destroy, :update_subjects]
  before_action :set_form_data, only: [:new, :edit]
  layout 'empty', only: [:fetch]

  def index
    @klasses = Klass.all
    @sections = Section.includes(:klass).where(term_id: current_term.id)
  end

  def fetch
    @sections = @klass.current_sections(current_term.id)
  end

  def show
  end

  def new
    @section = Section.new
  end

  def edit
  end

  def create
    @section = @klass.sections.new(section_params)
    @section.term = current_term

    respond_to do |format|
      if @section.save
        format.html { redirect_to administrator_sections_url, notice: 'Section was successfully created.' }
        format.json { render :show, status: :created, location: @section }
      else
        format.html { render :new }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @section.update(section_params)
        format.html { redirect_to administrator_sections_url, notice: 'Section was successfully updated.' }
        format.json { render :show, status: :ok, location: @section }
      else
        format.html { render :edit }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @section.destroy
    respond_to do |format|
      format.html { redirect_to administrator_klass_sections_url(@klass), notice: 'Section was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def update_subjects
    @subjects  = @section.subjects
    render json: @subjects.map { |subject| subject.as_json(:only => [:id, :name]) }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_section
      @section = @klass.sections.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def section_params
      params.require(:section).permit(:name, :nickname, :incharge_id, section_subject_teachers_attributes: [:id, :subject_id, :teacher_id, :klass_id, :term_id, :institution_id, :_destroy])
    end

    def set_klass
      @klass = Klass.find(params[:klass_id])
    end

    def set_form_data
      @teachers = Teacher.all.to_a
      @subjects = Subject.all.to_a
    end

    def check_current_term
      return redirect_to(administrator_terms_path) unless current_term.present?
    end
end
