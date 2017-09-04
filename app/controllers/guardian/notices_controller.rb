class Guardian::NoticesController < ApplicationController
  def index
    @notices = Notice.lookup(params[:search], where_clause)
  end

  def autocomplete
    render json: autocomplete_query(Notice, ["title"], where_clause).map{|notice| {search: notice.title}}
  end

  private
    def where_clause
      current_section = selected_user.current_section(current_term.id)

      {_or: [{klass_id: current_section.klass_id, notice_type: 'Class Specific'}, {klass_id: current_section.klass_id, section_id: current_section.id}, {notice_type: 'Guardian'}]}
    end
end
