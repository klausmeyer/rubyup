# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_04_06_174710) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "identities", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "github_api_key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_identities_on_email", unique: true
  end

  create_table "jobs", force: :cascade do |t|
    t.bigint "repository_id", null: false
    t.bigint "identity_id", null: false
    t.string "name", null: false
    t.json "config", null: false
    t.string "state", null: false
    t.text "logs"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "version_from_id", null: false
    t.bigint "version_to_id", null: false
    t.index ["identity_id"], name: "index_jobs_on_identity_id"
    t.index ["repository_id"], name: "index_jobs_on_repository_id"
    t.index ["version_from_id"], name: "index_jobs_on_version_from_id"
    t.index ["version_to_id"], name: "index_jobs_on_version_to_id"
  end

  create_table "repositories", force: :cascade do |t|
    t.string "name", null: false
    t.string "url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "branch", default: "master", null: false
    t.index ["name"], name: "index_repositories_on_name", unique: true
    t.index ["url"], name: "index_repositories_on_url", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "string", null: false
    t.string "state", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["string"], name: "index_versions_on_string", unique: true
  end

  add_foreign_key "jobs", "identities"
  add_foreign_key "jobs", "repositories"
  add_foreign_key "jobs", "versions", column: "version_from_id"
  add_foreign_key "jobs", "versions", column: "version_to_id"
end
