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

ActiveRecord::Schema[7.0].define(version: 2025_03_17_163201) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "questions", force: :cascade do |t|
    t.bigint "survey_id", null: false
    t.text "content"
    t.string "question_type"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "options"
    t.boolean "required"
    t.bigint "survey_variation_id"
    t.index ["survey_id"], name: "index_questions_on_survey_id"
    t.index ["survey_variation_id"], name: "index_questions_on_survey_variation_id"
  end

  create_table "responses", force: :cascade do |t|
    t.bigint "survey_id", null: false
    t.bigint "question_id", null: false
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_responses_on_question_id"
    t.index ["survey_id"], name: "index_responses_on_survey_id"
  end

  create_table "survey_variations", force: :cascade do |t|
    t.bigint "survey_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survey_id"], name: "index_survey_variations_on_survey_id"
  end

  create_table "surveys", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "questions", "survey_variations"
  add_foreign_key "questions", "surveys"
  add_foreign_key "responses", "questions"
  add_foreign_key "responses", "surveys"
  add_foreign_key "survey_variations", "surveys"
end
