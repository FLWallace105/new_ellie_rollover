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

ActiveRecord::Schema.define(version: 2018_07_25_181048) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ellie_rollover_setup", force: :cascade do |t|
    t.string "product_title"
    t.bigint "product_id"
    t.string "new_title"
    t.decimal "new_price", precision: 10, scale: 2
    t.string "new_template"
    t.boolean "is_rolled_over", default: false
  end

end
