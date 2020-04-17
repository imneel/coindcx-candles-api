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

ActiveRecord::Schema.define(version: 2020_04_17_051251) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "challenges", id: false, force: :cascade do |t|
    t.integer "challenge_id"
    t.integer "college_id"
  end

  create_table "colleges", id: false, force: :cascade do |t|
    t.integer "college_id"
    t.integer "contest_id"
  end

  create_table "contests", id: false, force: :cascade do |t|
    t.integer "contest_id"
    t.integer "hacker_id"
    t.string "name", limit: 200
  end

  create_table "markets", force: :cascade do |t|
    t.string "pair", null: false
    t.string "symbol", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["pair"], name: "index_markets_on_pair", unique: true
    t.index ["symbol"], name: "index_markets_on_symbol", unique: true
  end

  create_table "submission_stats", id: false, force: :cascade do |t|
    t.integer "challenge_id"
    t.integer "total_submissions"
    t.integer "total_accepted_submissions"
  end

  create_table "trades", force: :cascade do |t|
    t.bigint "market_id", null: false
    t.decimal "price", null: false
    t.decimal "quantity", null: false
    t.bigint "traded_at", null: false
    t.boolean "market_maker", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["market_id", "traded_at"], name: "index_trades_on_market_id_and_traded_at"
    t.index ["market_id"], name: "index_trades_on_market_id"
  end

  create_table "view_stats", id: false, force: :cascade do |t|
    t.integer "challenge_id"
    t.integer "total_views"
    t.integer "total_unique_views"
  end

  add_foreign_key "trades", "markets"
end
