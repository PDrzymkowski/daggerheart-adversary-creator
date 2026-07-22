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

ActiveRecord::Schema[8.1].define(version: 2026_07_21_124223) do
  create_table "adversaries", force: :cascade do |t|
    t.string "adversary_type", null: false
    t.integer "atk", null: false
    t.string "attack_damage", null: false
    t.string "attack_name", null: false
    t.string "attack_range", null: false
    t.string "attack_type"
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "difficulty", null: false
    t.json "experiences", default: []
    t.integer "hp", null: false
    t.string "motives_tactics"
    t.string "name", null: false
    t.integer "stress", null: false
    t.boolean "template", default: false, null: false
    t.integer "threshold_major"
    t.integer "threshold_severe"
    t.integer "tier", null: false
    t.string "type_suffix"
    t.datetime "updated_at", null: false
  end

  create_table "features", force: :cascade do |t|
    t.integer "adversary_id", null: false
    t.datetime "created_at", null: false
    t.text "description", null: false
    t.string "feature_type", null: false
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["adversary_id"], name: "index_features_on_adversary_id"
  end

  add_foreign_key "features", "adversaries"
end
