class Teacher::TermsController < ApplicationController
  before_action :set_term, only: [:update_selected_term]

  def index
    @terms = Term.lookup(params[:search])
    @new_term = Term.new
  end

  def update_selected_term
    session[:selected_term] = @term.id
    respond_to do |format|
      format.html { redirect_to terms_url, notice: "#{@term.name} has been selected successfully" }
      format.json { head :no_content }
    end
  end

  private
    def set_term
      @term = Term.find(params[:id])
      redirect_to(terms_url, error: "#{@term.name} is not activated yet.") if @term.initialized?
    end
end
