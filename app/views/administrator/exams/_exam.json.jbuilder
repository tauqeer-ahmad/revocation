json.extract! exam, :id, :name, :start_date, :comment, :created_at, :updated_at
json.url administrator_exam_url(exam, format: :json)
