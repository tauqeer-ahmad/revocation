class Administrator::TermsController < ApplicationController
  before_action :set_term, only: [:show, :edit, :update, :destroy, :update_selected_term]
  before_action :validate_status, only: :update

  def index
    @terms = Term.lookup(params[:search])
    @new_term = Term.new
  end

  def show
    @sections = Section.includes(
                          :klass,
                          :subjects,
                          :teachers,
                          :marksheets,
                          :attendance_sheets,
                          :assignments,
                          :question_papers,
                          :section_students
                        ).where(term_id: @term.id)
  end

  def new
    @term = Term.new
  end

  def edit
  end

  def create
    @term = Term.new(term_params)

    if @term.update_state('initialized')
      redirect_to administrator_terms_url, notice: 'Term was successfully created.'
    else
      flash.now[:error] = @term.errors.full_messages.to_sentence
      render :new
    end
  end

  def update
    if @term.update(term_params) && @term.update_state(params[:term][:status])
      redirect_to administrator_terms_url, notice: 'Term was successfully updated.'
    else
      flash.now[:error] = @term.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @term.destroy

    redirect_to administrator_terms_url, notice: 'Term was successfully destroyed.'
  end

  def update_selected_term
    session[:selected_term] = @term.id
    respond_to do |format|
      format.html { redirect_to administrator_terms_url, notice: "#{@term.name} has been selected successfully" }
      format.json { head :no_content }
    end
  end

  private
    def set_term
      @term = Term.find(params[:id])
    end

    def term_params
      params.require(:term).permit(:name, :start_date, :end_date)
    end

    def validate_status
      redirect_to administrator_terms_url, notice: 'Invalid Status.' unless params[:term][:status].in? Term.aasm.states.map(&:name).map(&:to_s)
    end
end
