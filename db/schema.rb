# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170604204219) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assignments", force: :cascade do |t|
    t.datetime "assigned_at"
    t.datetime "submission_deadline"
    t.string   "heading"
    t.text     "task"
    t.integer  "teacher_id"
    t.integer  "section_id"
    t.integer  "subject_id"
    t.integer  "term_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["section_id"], name: "index_assignments_on_section_id", using: :btree
    t.index ["subject_id"], name: "index_assignments_on_subject_id", using: :btree
    t.index ["teacher_id"], name: "index_assignments_on_teacher_id", using: :btree
    t.index ["term_id"], name: "index_assignments_on_term_id", using: :btree
  end

  create_table "attendance_sheets", force: :cascade do |t|
    t.date     "name"
    t.integer  "section_id"
    t.integer  "entity",     default: 0
    t.integer  "present"
    t.integer  "absent"
    t.integer  "leave"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "term_id"
    t.index ["section_id"], name: "index_attendance_sheets_on_section_id", using: :btree
    t.index ["term_id"], name: "index_attendance_sheets_on_term_id", using: :btree
  end

  create_table "attendances", force: :cascade do |t|
    t.string   "attendee_type"
    t.integer  "attendee_id"
    t.integer  "attendance_sheet_id"
    t.integer  "status",              default: 0
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "term_id"
    t.index ["attendance_sheet_id"], name: "index_attendances_on_attendance_sheet_id", using: :btree
    t.index ["attendee_type", "attendee_id"], name: "index_attendances_on_attendee_type_and_attendee_id", using: :btree
    t.index ["term_id"], name: "index_attendances_on_term_id", using: :btree
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.string   "data_fingerprint"
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type", using: :btree
  end

  create_table "exam_marks", force: :cascade do |t|
    t.integer  "obtained"
    t.integer  "total"
    t.integer  "passing_marks"
    t.text     "comment"
    t.integer  "term_id"
    t.integer  "subject_id"
    t.integer  "klass_id"
    t.integer  "exam_id"
    t.integer  "section_id"
    t.integer  "student_id"
    t.integer  "marksheet_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["exam_id"], name: "index_exam_marks_on_exam_id", using: :btree
    t.index ["klass_id"], name: "index_exam_marks_on_klass_id", using: :btree
    t.index ["marksheet_id"], name: "index_exam_marks_on_marksheet_id", using: :btree
    t.index ["section_id"], name: "index_exam_marks_on_section_id", using: :btree
    t.index ["student_id"], name: "index_exam_marks_on_student_id", using: :btree
    t.index ["subject_id"], name: "index_exam_marks_on_subject_id", using: :btree
    t.index ["term_id"], name: "index_exam_marks_on_term_id", using: :btree
  end

  create_table "exam_timetables", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.date     "paper_date"
    t.integer  "term_id"
    t.integer  "subject_id"
    t.integer  "klass_id"
    t.integer  "exam_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exam_id"], name: "index_exam_timetables_on_exam_id", using: :btree
    t.index ["klass_id"], name: "index_exam_timetables_on_klass_id", using: :btree
    t.index ["subject_id"], name: "index_exam_timetables_on_subject_id", using: :btree
    t.index ["term_id"], name: "index_exam_timetables_on_term_id", using: :btree
  end

  create_table "exams", force: :cascade do |t|
    t.string   "name"
    t.date     "start_date"
    t.text     "comment"
    t.integer  "term_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["term_id"], name: "index_exams_on_term_id", using: :btree
  end

  create_table "institutions", force: :cascade do |t|
    t.string   "name"
    t.text     "location"
    t.integer  "latitude"
    t.integer  "longitude"
    t.string   "city",                limit: 20
    t.string   "country",             limit: 20
    t.text     "description"
    t.string   "sector",              limit: 20
    t.string   "level",               limit: 20
    t.string   "status",              limit: 12
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "subdomain",           limit: 15
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "email",               limit: 60
    t.string   "phone_number",        limit: 60
    t.string   "fax_number",          limit: 60
    t.string   "address",             limit: 100
    t.string   "contact_description", limit: 150
    t.string   "facebook_url",        limit: 100
    t.string   "twitter_url",         limit: 100
    t.string   "linkedin_url",        limit: 100
    t.string   "video_url",           limit: 100
    t.index ["subdomain"], name: "index_institutions_on_subdomain", using: :btree
  end

  create_table "klasses", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "marksheets", force: :cascade do |t|
    t.integer  "term_id"
    t.integer  "subject_id"
    t.integer  "klass_id"
    t.integer  "exam_id"
    t.integer  "section_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exam_id"], name: "index_marksheets_on_exam_id", using: :btree
    t.index ["klass_id"], name: "index_marksheets_on_klass_id", using: :btree
    t.index ["section_id"], name: "index_marksheets_on_section_id", using: :btree
    t.index ["subject_id"], name: "index_marksheets_on_subject_id", using: :btree
    t.index ["term_id", "exam_id", "klass_id", "section_id", "subject_id"], name: "marksheet_combined_index", unique: true, using: :btree
    t.index ["term_id"], name: "index_marksheets_on_term_id", using: :btree
  end

  create_table "notes", force: :cascade do |t|
    t.string   "heading",     limit: 100,                     null: false
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.string   "color",       limit: 7,   default: "#ffffcc"
    t.index ["user_id"], name: "index_notes_on_user_id", using: :btree
  end

  create_table "question_papers", force: :cascade do |t|
    t.text     "content"
    t.integer  "teacher_id"
    t.integer  "subject_id"
    t.integer  "section_id"
    t.integer  "klass_id"
    t.integer  "exam_id"
    t.integer  "term_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exam_id"], name: "index_question_papers_on_exam_id", using: :btree
    t.index ["klass_id"], name: "index_question_papers_on_klass_id", using: :btree
    t.index ["section_id"], name: "index_question_papers_on_section_id", using: :btree
    t.index ["subject_id"], name: "index_question_papers_on_subject_id", using: :btree
    t.index ["teacher_id", "term_id"], name: "index_question_papers_on_teacher_id_and_term_id", using: :btree
    t.index ["teacher_id"], name: "index_question_papers_on_teacher_id", using: :btree
    t.index ["term_id"], name: "index_question_papers_on_term_id", using: :btree
  end

  create_table "section_students", force: :cascade do |t|
    t.integer  "section_id"
    t.integer  "student_id"
    t.integer  "term_id"
    t.integer  "klass_id"
    t.string   "roll_number", limit: 32
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "section_subject_teachers", force: :cascade do |t|
    t.integer  "section_id"
    t.integer  "subject_id"
    t.integer  "teacher_id"
    t.integer  "klass_id"
    t.integer  "term_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sections", force: :cascade do |t|
    t.string   "name"
    t.string   "nickname"
    t.integer  "term_id"
    t.integer  "klass_id"
    t.integer  "incharge_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "subjects", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "terms", force: :cascade do |t|
    t.string   "name"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "status",     limit: 16
  end

  create_table "timetables", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "day_of_week"
    t.integer  "term_id"
    t.integer  "section_id"
    t.integer  "subject_id"
    t.integer  "klass_id"
    t.integer  "teacher_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["klass_id"], name: "index_timetables_on_klass_id", using: :btree
    t.index ["section_id"], name: "index_timetables_on_section_id", using: :btree
    t.index ["subject_id"], name: "index_timetables_on_subject_id", using: :btree
    t.index ["teacher_id"], name: "index_timetables_on_teacher_id", using: :btree
    t.index ["term_id"], name: "index_timetables_on_term_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                             default: "", null: false
    t.string   "encrypted_password",                default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "type_of"
    t.string   "first_name",             limit: 50
    t.string   "last_name",              limit: 50
    t.string   "address"
    t.string   "role",                   limit: 12
    t.string   "roll_number",            limit: 12
    t.string   "qualification"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "enrollment_term_id"
    t.string   "mobile",                 limit: 25
    t.string   "phone",                  limit: 25
    t.date     "dob"
    t.string   "gender",                 limit: 7
    t.string   "cnic",                   limit: 16
    t.string   "profession",             limit: 60
    t.integer  "guardian_id"
    t.integer  "institution_id"
    t.string   "registration_number",    limit: 20
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["guardian_id"], name: "index_users_on_guardian_id", using: :btree
    t.index ["institution_id"], name: "index_users_on_institution_id", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "assignments", "sections"
  add_foreign_key "assignments", "subjects"
  add_foreign_key "assignments", "terms"
  add_foreign_key "attendance_sheets", "terms"
  add_foreign_key "attendances", "attendance_sheets"
  add_foreign_key "attendances", "terms"
  add_foreign_key "notes", "users"
  add_foreign_key "question_papers", "exams"
  add_foreign_key "question_papers", "klasses"
  add_foreign_key "question_papers", "sections"
  add_foreign_key "question_papers", "subjects"
  add_foreign_key "question_papers", "terms"
  add_foreign_key "users", "institutions"
end
