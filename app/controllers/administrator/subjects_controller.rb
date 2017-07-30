class Administrator::SubjectsController < ApplicationController
  before_action :set_subject, only: [:show, :edit, :update, :destroy]

  def index
    @subjects = Subject.lookup params[:search]
    @new_subject = Subject.new
  end

  def show
  end

  def new
    @subject = Subject.new
  end

  def edit
  end

  def create
    @subject = Subject.new(subject_params)

    respond_to do |format|
      if @subject.save
        format.html { redirect_to administrator_subjects_path, notice: 'Subject was successfully created.' }
        format.json { render :show, status: :created, location: @subject }
      else
        format.html { render :new }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @subject.update(subject_params)
        format.html { redirect_to administrator_subjects_path, notice: 'Subject was successfully updated.' }
        format.json { render :show, status: :ok, location: @subject }
      else
        format.html { render :edit }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @subject.destroy
    respond_to do |format|
      format.html { redirect_to administrator_subjects_url, notice: 'Subject was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def bulk_insert
    Subject.create(bulk_subject_params)
    redirect_to administrator_subjects_path
  end

  def autocomplete
    render json: Subject.search(params[:search], fields: ["name"], load: false, misspellings: {below: 5}, limit: 10).map{|subject| {search: subject.name}}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subject
      @subject = Subject.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subject_params
      params.require(:subject).permit(:name, :description, :color).tap do |custom_params|
        custom_params[:color] ||= Subject::COLORS.sample
      end
    end

    def bulk_subject_params
      params.permit(subjects: [:name, :description])[:subjects]
    end
end
