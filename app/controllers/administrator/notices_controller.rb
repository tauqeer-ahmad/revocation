class Administrator::NoticesController < ApplicationController
  before_action :set_notice, only: [:edit, :update, :destroy]
  before_action :set_klasses, only: [:index, :edit]

  def index
    @notices = Notice.lookup params[:search]
    @new_notice = Notice.new(notice_type: 'General')
    @sections = []
  end

  def edit
    @sections = @notice.klass.present? ? @notice.klass.sections.where(term_id: current_term.id).pluck(:name, :id) : []
  end

  def create
    @notice = Notice.new(notice_params)

    respond_to do |format|
      if @notice.save
        format.html { redirect_to administrator_notices_path, notice: 'Notice was successfully created.' }
        format.json { render :show, status: :created, location: @notice }
      else
        format.html { render :new }
        format.json { render json: @notice.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @notice.update(notice_update_params)
        format.html { redirect_to administrator_notices_path, notice: 'Notice was successfully updated.' }
        format.json { render :show, status: :ok, location: @notice }
      else
        format.html { render :edit }
        format.json { render json: @notice.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @notice.destroy
    respond_to do |format|
      format.html { redirect_to administrator_notice_url, notice: 'Notice was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def autocomplete
    render json: autocomplete_query(Notice, ["title"]).map{|notice| {search: notice.title}}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notice
      @notice = Notice.find(params[:id])
    end

    def set_klasses
      @klasses  = Klass.pluck(:name, :id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def notice_params
      params.require(:notice).permit(:title, :message, :notice_type, :klass_id, :section_id)
    end

    def notice_update_params
      params.require(:notice).permit(:title, :message)
    end
end
