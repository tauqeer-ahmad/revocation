class Administrator::GradingSystemsController < ApplicationController
  before_action :set_grading_system, only: [:show, :edit, :update, :destroy]

  def index
    @grading_systems = GradingSystem.all
    @new_grading_system = GradingSystem.new
  end

  def show
  end

  def new
    @grading_system = GradingSystem.new
  end

  def edit
  end

  def create
    @grading_system = GradingSystem.new(grading_system_params)

    if @grading_system.save
      redirect_to [:administrator, @grading_system], notice: 'Grading system was successfully created.'
    else
      render :new
    end
  end

  def update
    if @grading_system.update(grading_system_params)
      redirect_to [:administrator, @grading_system], notice: 'Grading system was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @grading_system.destroy
    redirect_to administrator_grading_systems_url, notice: 'Grading system was successfully destroyed.'
  end

  def move
    @grading_system = GradingSystem.find(params[:id])
    @grading_system.move_to! params[:position]
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_grading_system
      @grading_system = GradingSystem.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def grading_system_params
      params.require(:grading_system).permit(:name, :description, grades_attributes: [:id, :name, :start_point, :end_point, :points, :_destroy])
    end
end
