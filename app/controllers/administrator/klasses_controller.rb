class Administrator::KlassesController < ApplicationController
  before_action :set_klass, only: [:show, :edit, :update, :destroy]

  def index
    @klasses = Klass.lookup params[:search], {order: {position: :asc}}
    @new_klass = Klass.new
  end

  def show
    @sections = @klass.current_sections(current_term.id).includes(:incharge, { section_subject_teachers: [:teacher] }, { section_students: [:student] }, :teachers, :students)
    @students = @sections.collect(&:students).flatten
    @teachers = @sections.collect(&:teachers).flatten
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
    @klass.reload
    @klass.save
    respond_to do |format|
      format.html { redirect_to administrator_klasses_url, notice: 'Class was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def bulk_insert
    Klass.create(bulk_klass_params)
    redirect_to administrator_klasses_path
  end

  def autocomplete
    render json: autocomplete_query(Klass, ["name"]).map{|klass| {search: klass.name}}
  end

  def move
    @klass = Klass.find(params[:id])
    @klass.move_to! params[:position]
    Klass.reindex
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
