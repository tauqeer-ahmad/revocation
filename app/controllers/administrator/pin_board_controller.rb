class Administrator::PinBoardController < ApplicationController
  def landing
  end

  def create_note
    @note = current_user.notes.create(heading: params[:heading], description: params[:description])
  end

  def delete_note
    current_user.notes.find(params[:note_id]).delete
  end
end
