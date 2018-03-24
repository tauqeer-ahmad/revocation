class Teacher::StudentsController < ApplicationController

  before_action :set_section, only: [:results, :autocomplete, :results_report]
  before_action :set_student, only: [:results, :results_report]

  def results
    @results = @student.results_json(current_term)
    render layout: false
  end

  def results_report
    @results = @student.results_json(current_term)
    return redirect_back(fallback_location: root_path, alert: "No Results found") if @results.blank?
    respond_to do |format|
      format.xlsx {
        response.headers['Content-Disposition'] = "attachment; filename=Marksheet - #{@student.name}.xlsx"
      }
      format.pdf do
        render pdf: "Marksheet - #{@student.name}",
        disposition: 'attachment',
        template: "shared/student/_results_report.html.erb",
        layout: 'pdf.html.erb',
        javascript_delay: 500,
        viewport_size: '1000x740',
        zoom: 0.9,
        margin:  {
                    top: 25,
                    bottom: 20
                },
        header: {
                  html: {
                          template: 'shared/pdfs/header',
                          layout: 'pdf_plain',
                          locals: {heading: "Marksheet Report", left_tag: @student.name}
                        },
                  line: true,
                  spacing: 6
                },
        footer: {
                  html: {
                          template:'shared/pdfs/footer',
                          layout:  'pdf_plain',
                          locals: {left_tag: "Created At: #{Time.now.strftime('%d %B %Y %l-%M %p')}"}
                        },
                  spacing: 6,
                  line:  true
                }
      end
    end
  end

  def autocomplete
    render json: autocomplete_query(Student, ["first_name", "last_name"], {section_id: @section.id}).map{|student| {search: [student.first_name, ' ', student.last_name].join}}
  end

  private

  def set_section
    @section = Section.find(params[:section_id])
  end

  def set_student
     @student = Student.find(params[:id])
  end

end
