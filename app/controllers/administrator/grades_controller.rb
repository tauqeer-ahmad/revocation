class Administrator::GradesController < ApplicationController
  def move
    @grade = Grade.find(params[:id])
    @grade.move_to! params[:position]
  end
end
