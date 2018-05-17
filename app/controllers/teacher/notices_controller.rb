class Teacher::NoticesController < ApplicationController
  def index
    @notices = Notice.lookup(params[:search], {includes: [:klass, :section], order: {updated_at: :desc}, where: where_clause, page: params[:page], per_page: Notice::DEFAULT_PER_PAGE})
  end

  def autocomplete
    render json: autocomplete_query(Notice, ["title"], where_clause).map{|notice| {search: notice.title}}
  end

  private
    def where_clause
      {notice_type: Notice::TEACHER_TYPES}
    end
end
