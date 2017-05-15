class Administrator::HomeController < ApplicationController
  def index
    @rolling = {
      students: Student.count,
      teachers: Teacher.count,
      klasses: Klass.count,
      sections: Section.count,
    }
  end

  def pin_board
  end

  def create_note
    @note = current_administrator.notes.create(heading: params[:heading], description: params[:description])
  end

  def delete_note
    current_administrator.notes.find(params[:note_id]).delete
  end
end
