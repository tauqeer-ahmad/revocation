class Admin::AdministratorsController < ApplicationController
  before_action :set_institution
  before_action :set_administrator, only: [:show, :edit, :update, :destroy]

  def index
    @administrators = @institution.administrators
  end

  def show
  end

  def new
    @administrator = Administrator.new
  end

  def edit
  end

  def create
    @administrator = @institution.administrators.new(administrator_params)
    password = SecureRandom.hex(8)
    @administrator.password = password
    respond_to do |format|
      if @administrator.save
        AdministratorMailer.send_password(@administrator, @institution, password).deliver!
        format.html { redirect_to [:admin, @institution, @administrator], notice: 'Administrator was successfully created.' }
        format.json { render :show, status: :created, location: @administrator }
      else
        format.html { render :new }
        format.json { render json: @administrator.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @administrator.update(administrator_params)
        format.html { redirect_to [:admin, @institution, @administrator], notice: 'Administrator was successfully updated.' }
        format.json { render :show, status: :ok, location: @administrator }
      else
        format.html { render :edit }
        format.json { render json: @administrator.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @administrator.destroy
    respond_to do |format|
      format.html { redirect_to admin_institution_administrators_url(@institution), notice: 'Administrator was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_administrator
      @administrator = Administrator.find(params[:id])
    end

    def set_institution
      @institution = Institution.find(params[:institution_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def administrator_params
      params.require(:administrator).permit(:first_name, :last_name, :email, :avatar)
    end
end
