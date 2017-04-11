class Administrator::KlassesController < ApplicationController
  before_action :set_klass, only: [:show, :edit, :update, :destroy]

  def index
    @klasses = current_institute.klasses
  end

  def show
  end

  def new
    @klass = Klass.new
  end

  def edit
  end

  def create
    @klass = current_institute.klasses.new(klass_params)

    respond_to do |format|
      if @klass.save
        format.html { redirect_to [:administrator, @klass], notice: 'Class was successfully created.' }
        format.json { render :show, status: :created, location: @klass }
      else
        format.html { render :new }
        format.json { render json: @klass.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @klass.update(class_params)
        format.html { redirect_to [:administrator, @klass], notice: 'Class was successfully updated.' }
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_klass
      @klass = current_institute.klasses.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def klass_params
       params.require(:klass).permit(:name, :code)
    end
end
