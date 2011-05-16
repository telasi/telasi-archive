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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110516071831) do

  create_table "books", :force => true do |t|
    t.string   "name"
    t.integer  "order_by"
    t.integer  "nomenclature_id"
    t.integer  "place_id"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "page_count"
    t.integer  "custom_order"
    t.integer  "book_year"
    t.integer  "enter_year"
    t.string   "book_presenter"
  end

  add_index "books", ["book_year"], :name => "index_books_on_book_year"
  add_index "books", ["enter_year"], :name => "index_books_on_enter_year"
  add_index "books", ["nomenclature_id"], :name => "index_books_on_nomenclature_id"
  add_index "books", ["place_id", "custom_order"], :name => "index_books_on_place_id_and_custom_order"
  add_index "books", ["place_id", "order_by"], :name => "index_books_on_place_id_and_order_by"

  create_table "direqcias", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "direqcias", ["code"], :name => "index_direqcias_on_code"

  create_table "nomenclatures", :force => true do |t|
    t.integer  "direqcia_id"
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "nomenclatures", ["code"], :name => "index_nomenclatures_on_code"
  add_index "nomenclatures", ["direqcia_id"], :name => "index_nomenclatures_on_direqcia_id"

  create_table "places", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "places", ["name"], :name => "index_places_on_name"
  add_index "places", ["parent_id"], :name => "index_places_on_parent_id"

  create_table "task_bodies", :force => true do |t|
    t.integer  "task_id"
    t.integer  "from_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks", :force => true do |t|
    t.string   "subject"
    t.text     "last_body"
    t.string   "status"
    t.integer  "from_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tasks", ["from_id"], :name => "index_tasks_on_from_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "hashed_password"
    t.string   "salt"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.boolean  "admin"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "editarchive",     :default => false
  end

  add_index "users", ["name"], :name => "index_users_on_name", :unique => true

end
