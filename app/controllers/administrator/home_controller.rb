class Administrator::HomeController < ApplicationController
  def index
    @rolling = {
      students: Student.count,
      teachers: Teacher.count,
      klasses: Klass.count,
      sections: Section.count,
    }
  end
end
