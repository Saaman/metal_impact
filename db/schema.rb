# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20120725153940) do

  create_table "artists", :force => true do |t|
    t.string   "name",       :limit => 127, :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "artists", ["created_at"], :name => "index_artists_on_created_at"
  add_index "artists", ["name"], :name => "index_artists_on_name"

  create_table "artists_products", :id => false, :force => true do |t|
    t.integer "artist_id",  :null => false
    t.integer "product_id", :null => false
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "music_labels", :force => true do |t|
    t.string   "name",        :null => false
    t.string   "website",     :null => false
    t.string   "distributor"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "music_labels", ["name"], :name => "index_music_labels_on_name", :unique => true

  create_table "practices", :force => true do |t|
    t.integer  "artist_id",  :null => false
    t.integer  "kind_cd",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "practices", ["artist_id", "kind_cd"], :name => "index_practices_on_artist_id_and_kind_cd", :unique => true
  add_index "practices", ["artist_id"], :name => "index_practices_on_artist_id"

  create_table "products", :force => true do |t|
    t.string   "title",              :limit => 511, :null => false
    t.string   "type",               :limit => 7,   :null => false
    t.date     "release_date",                      :null => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "cover_file_name"
    t.string   "cover_content_type"
    t.integer  "cover_file_size"
    t.datetime "cover_updated_at"
  end

  add_index "products", ["created_at"], :name => "index_products_on_created_at"
  add_index "products", ["release_date"], :name => "index_products_on_release_date"
  add_index "products", ["title"], :name => "index_products_on_title"
  add_index "products", ["type"], :name => "index_products_on_type"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "email",                                                 :null => false
    t.string   "encrypted_password",                                    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",                       :default => 0
    t.datetime "locked_at"
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.integer  "role_cd",                               :default => 0,  :null => false
    t.string   "pseudo",                 :limit => 127, :default => "", :null => false
    t.date     "date_of_birth"
    t.integer  "gender_cd"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["role_cd"], :name => "index_users_on_role_cd"

end
