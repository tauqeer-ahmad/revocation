class Administrator::GuardiansController < ApplicationController
  before_action :set_guardian, only: [:show, :edit, :update, :destroy]

  def index
    @guardians = Guardian.all
    @new_guardian = Guardian.new
  end

  def show
  end

  def new
    @guardian = Guardian.new
  end

  def edit
  end

  def create
    @guardian = Guardian.new(guardian_params)
    password = SecureRandom.hex(9)
    @guardian.password = password
    respond_to do |format|
      if @guardian.save
        GuardianMailer.send_password(@guardian, current_institute, password).deliver!
        format.html { redirect_to administrator_guardians_url, notice: 'Guardian was successfully created.' }
        format.json { render :show, status: :created, location: @guardian }
      else
        format.html { render :new }
        format.json { render json: @guardian.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @guardian.update(guardian_params)
        format.html { redirect_to administrator_guardians_url, notice: 'Guardian was successfully updated.' }
        format.json { render :show, status: :ok, location: @guardian }
      else
        format.html { render :edit }
        format.json { render json: @guardian.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @guardian.destroy
    respond_to do |format|
      format.html { redirect_to administrator_guardians_url, notice: 'Guardian was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_guardian
      @guardian = Guardian.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def guardian_params
      params.require(:guardian).permit(:first_name, :last_name, :email, :avatar, :cnic, :profession)
    end
end