class Administrator::TermsController < ApplicationController
  before_action :set_term, only: [:show, :edit, :update, :destroy, :update_selected_term]

  def index
    @terms = Term.lookup(params[:search])
    @new_term = Term.new
  end

  def show
    @klasses = Klass.all
  end

  def new
    @term = Term.new
  end

  def edit
  end

  def create
    @term = Term.new(term_params)

    if @term.save
      redirect_to administrator_terms_url, notice: 'Term was successfully created.'
    else
      flash.now[:error] = @term.errors.full_messages.to_sentence
      render :new
    end
  end

  def update
    if @term.update(term_params)
      redirect_to administrator_terms_url, notice: 'Term was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @term.destroy
    redirect_to administrator_terms_url, notice: 'Term was successfully destroyed.'
  end

  def update_selected_term
    session[:selected_term] = @term.id
    redirect_to administrator_terms_url, notice: "#{@term.name} has been selected successfully"
  end

  private
    def set_term
      @term = Term.find(params[:id])
    end

    def term_params
      params.require(:term).permit(:name, :start_date, :end_date, :status)
    end
end
