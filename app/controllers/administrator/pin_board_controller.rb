class Administrator::PinBoardController < ApplicationController
  def show
  end

  def create
    @note = current_user.notes.create(note_params)
  end

  def destroy
    current_user.notes.find(params[:note_id]).delete
  end

  def update
    @note = current_user.notes.find(params[:note_id])
    @note.update(note_params)
  end

  private
    def note_params
      params.require(:note).permit(:heading, :description, :color)
    end
end
