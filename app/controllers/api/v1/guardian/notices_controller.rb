class Api::V1::Guardian::NoticesController < Api::V1::Guardian::GuardianBaseController
  def index
    @notices = Notice.lookup(params[:search], {includes: [:klass, :section], order: {updated_at: :desc}, where: where_clause, page: params[:page], per_page: Notice::DEFAULT_PER_PAGE})

    render json: @notices
  end

  private
    def where_clause
      current_section = selected_user.current_section(current_term.id)

      {_or: [{klass_id: current_section.klass_id, notice_type: 'Class Specific'}, {klass_id: current_section.klass_id, section_id: current_section.id}, {notice_type: 'Guardian'}]}
    end
end
