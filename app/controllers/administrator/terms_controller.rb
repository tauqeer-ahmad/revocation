class Administrator::TermsController < ApplicationController
  before_action :set_term, only: [:show, :edit, :update, :destroy]

  def index
    @terms = current_institute.terms
  end

  def show
  end

  def new
    @term = current_institute.terms.new
  end

  def edit
  end

  def create
    @term = current_institute.terms.new(term_params)

    respond_to do |format|
      if @term.save
        format.html { redirect_to [:administrator, @term], notice: 'Term was successfully created.' }
        format.json { render :show, status: :created, location: @term }
      else
        format.html { render :new }
        format.json { render json: @term.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @term.update(term_params)
        format.html { redirect_to [:administrator, @term], notice: 'Term was successfully updated.' }
        format.json { render :show, status: :ok, location: @term }
      else
        format.html { render :edit }
        format.json { render json: @term.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @term.destroy
    respond_to do |format|
      format.html { redirect_to administrator_terms_url, notice: 'Term was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_term
      @term = current_institute.terms.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def term_params
      params.require(:term).permit(:name, :start_date, :end_date)
    end
end
