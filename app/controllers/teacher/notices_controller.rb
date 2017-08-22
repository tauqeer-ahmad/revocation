class Teacher::NoticesController < ApplicationController
  def index
    @notices = Notice.lookup(params[:search], where_clause)
  end

  def autocomplete
    render json: Notice.search(params[:search], fields: ["title"], where: where_clause, load: false, misspellings: {below: 5}, limit: 10).map{|notice| {search: notice.title}}
  end

  private
    def where_clause
      {notice_type: Notice::TEACHER_TYPES}
    end
end
