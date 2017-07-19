class Administrator::PinBoardController < ApplicationController
  def landing
  end

  def create_note
    @note = current_user.notes.create(heading: params[:heading], description: params[:description], color: params[:color])
  end

  def delete_note
    current_user.notes.find(params[:note_id]).delete
  end

  def update_note
    @note = current_user.notes.find(params[:note_id])
    @note.update(heading: params[:heading], description: params[:description], color: params[:color])
  end
end
