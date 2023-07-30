# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_07_29_163510) do
  create_table "batches", force: :cascade do |t|
    t.string "name"
    t.date "start_date"
    t.date "end_date"
    t.integer "course_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_batches_on_course_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "school_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["school_id"], name: "index_courses_on_school_id"
  end

  create_table "enrollments", force: :cascade do |t|
    t.integer "student_id", null: false
    t.integer "batch_id", null: false
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["batch_id"], name: "index_enrollments_on_batch_id"
    t.index ["student_id"], name: "index_enrollments_on_student_id"
  end

  create_table "schools", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_schools_on_user_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "name"
    t.string "roll_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "school_id", null: false
    t.string "email"
    t.integer "user_id"
    t.index ["email"], name: "index_students_on_email", unique: true
    t.index ["school_id"], name: "index_students_on_school_id"
    t.index ["user_id"], name: "index_students_on_user_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "user_type"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
  end

  add_foreign_key "batches", "courses"
  add_foreign_key "courses", "schools"
  add_foreign_key "enrollments", "batches"
  add_foreign_key "enrollments", "students"
  add_foreign_key "schools", "users"
  add_foreign_key "students", "schools"
end
