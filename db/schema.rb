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

ActiveRecord::Schema.define(version: 20170516022401) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attendance_sheets", force: :cascade do |t|
    t.date     "name"
    t.integer  "section_id"
    t.integer  "entity",     default: 0
    t.integer  "present"
    t.integer  "absent"
    t.integer  "leave"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["section_id"], name: "index_attendance_sheets_on_section_id", using: :btree
  end

  create_table "attendances", force: :cascade do |t|
    t.string   "attendee_type"
    t.integer  "attendee_id"
    t.integer  "attendance_sheet_id"
    t.integer  "status",              default: 0
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["attendance_sheet_id"], name: "index_attendances_on_attendance_sheet_id", using: :btree
    t.index ["attendee_type", "attendee_id"], name: "index_attendances_on_attendee_type_and_attendee_id", using: :btree
  end

  create_table "institutions", force: :cascade do |t|
    t.string   "name"
    t.text     "location"
    t.integer  "latitude"
    t.integer  "longitude"
    t.string   "city",        limit: 20
    t.string   "country",     limit: 20
    t.text     "description"
    t.string   "sector",      limit: 20
    t.string   "level",       limit: 20
    t.string   "status",      limit: 12
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "subdomain",   limit: 15
    t.index ["subdomain"], name: "index_institutions_on_subdomain", using: :btree
  end

  create_table "klasses", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["guardian_id"], name: "index_users_on_guardian_id", using: :btree
    t.index ["institution_id"], name: "index_users_on_institution_id", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "attendances", "attendance_sheets"
  add_foreign_key "notes", "users"
  add_foreign_key "users", "institutions"
end
