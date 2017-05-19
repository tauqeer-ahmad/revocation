class Administrator::KlassesController < ApplicationController
  before_action :set_klass, only: [:show, :edit, :update, :destroy]

  def index
    @klasses = Klass.lookup params[:search]
    @new_klass = Klass.new
  end

  def show
    @sections = @klass.sections.where(term_id: current_term.id).includes(:subjects)
    @students_count = @sections.collect(&:students).flatten.count
    @teachers_count = @sections.collect(&:teachers).flatten.count
  end

  def new
    @klass = Klass.new
  end

  def edit
  end

  def create
    @klass = Klass.new(klass_params)

    respond_to do |format|
      if @klass.save
        format.html { redirect_to administrator_klasses_url, notice: 'Class was successfully created.' }
        format.json { render :show, status: :created, location: @klass }
      else
        format.html { render :new }
        format.json { render json: @klass.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @klass.update(klass_params)
        format.html { redirect_to administrator_klasses_url, notice: 'Class was successfully updated.' }
        format.json { render :show, status: :ok, location: @klass }
      else
        format.html { render :edit }
        format.json { render json: @klass.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @klass.destroy
    respond_to do |format|
      format.html { redirect_to administrator_klasses_url, notice: 'Class was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def bulk_insert
    Klass.create(bulk_klass_params)
    redirect_to administrator_klasses_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_klass
      @klass = Klass.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def klass_params
       params.require(:klass).permit(:name, :code)
    end

    def bulk_klass_params
      params.permit(klasses: [:name, :code])[:klasses]
    end
end
