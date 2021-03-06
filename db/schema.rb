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

ActiveRecord::Schema.define(:version => 20130215142053) do

  create_table "activities", :force => true do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "activities", ["owner_id", "owner_type"], :name => "index_activities_on_owner_id_and_owner_type"
  add_index "activities", ["recipient_id", "recipient_type"], :name => "index_activities_on_recipient_id_and_recipient_type"
  add_index "activities", ["trackable_id", "trackable_type"], :name => "index_activities_on_trackable_id_and_trackable_type"

  create_table "albums", :force => true do |t|
    t.string   "title",          :limit => 511,                    :null => false
    t.date     "release_date",                                     :null => false
    t.string   "cover"
    t.integer  "kind_cd",                                          :null => false
    t.boolean  "published",                     :default => false, :null => false
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.integer  "music_label_id"
  end

  add_index "albums", ["created_at"], :name => "index_albums_on_created_at", :order => {"created_at"=>:desc}
  add_index "albums", ["kind_cd"], :name => "index_albums_on_kind_cd"
  add_index "albums", ["music_label_id"], :name => "index_albums_on_music_label_id"
  add_index "albums", ["release_date"], :name => "index_albums_on_release_date"
  add_index "albums", ["title"], :name => "index_albums_on_title"

  create_table "albums_artists", :id => false, :force => true do |t|
    t.integer "album_id",  :null => false
    t.integer "artist_id", :null => false
  end

  add_index "albums_artists", ["album_id", "artist_id"], :name => "index_albums_artists_on_album_id_and_artist_id", :unique => true

  create_table "artist_translations", :force => true do |t|
    t.integer  "artist_id"
    t.string   "locale"
    t.text     "biography"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "artist_translations", ["artist_id"], :name => "index_artist_translations_on_artist_id"
  add_index "artist_translations", ["locale"], :name => "index_artist_translations_on_locale"

  create_table "artists", :force => true do |t|
    t.string   "name",       :limit => 127,                    :null => false
    t.boolean  "published",                 :default => false, :null => false
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.string   "countries",  :limit => 127
  end

  add_index "artists", ["created_at"], :name => "index_artists_on_created_at"
  add_index "artists", ["name"], :name => "index_artists_on_name"

  create_table "artists_practices", :id => false, :force => true do |t|
    t.integer "artist_id",   :null => false
    t.integer "practice_id", :null => false
  end

  add_index "artists_practices", ["artist_id", "practice_id"], :name => "index_artists_practices_on_artist_id_and_practice_id", :unique => true

  create_table "contributions", :force => true do |t|
    t.string   "approvable_type", :null => false
    t.integer  "approvable_id",   :null => false
    t.integer  "event_cd",        :null => false
    t.string   "state",           :null => false
    t.text     "draft_object",    :null => false
    t.integer  "whodunnit_id",    :null => false
    t.text     "reason"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "contributions", ["approvable_type", "approvable_id"], :name => "index_contributions_on_approvable_type_and_approvable_id"
  add_index "contributions", ["created_at"], :name => "index_contributions_on_created_at"
  add_index "contributions", ["state"], :name => "index_contributions_on_state"

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

  create_table "import_entries", :force => true do |t|
    t.integer  "target_model_cd"
    t.integer  "source_id"
    t.integer  "target_id"
    t.integer  "import_source_file_id"
    t.text     "data",                                     :null => false
    t.string   "state",                 :default => "new", :null => false
    t.string   "type"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  add_index "import_entries", ["created_at"], :name => "index_import_entries_on_created_at"
  add_index "import_entries", ["import_source_file_id"], :name => "index_import_entries_on_import_source_file_id"
  add_index "import_entries", ["source_id", "target_model_cd"], :name => "index_import_entries_on_source_id_and_target_model_cd"
  add_index "import_entries", ["state"], :name => "index_import_entries_on_state"
  add_index "import_entries", ["target_id", "target_model_cd"], :name => "index_import_entries_on_target_id_and_target_model_cd"

  create_table "import_failures", :force => true do |t|
    t.text     "description",     :null => false
    t.integer  "import_entry_id", :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "import_failures", ["created_at"], :name => "index_import_failures_on_created_at"
  add_index "import_failures", ["import_entry_id"], :name => "index_import_failures_on_import_entry_id"

  create_table "import_source_files", :force => true do |t|
    t.string   "path",           :null => false
    t.integer  "source_type_cd"
    t.string   "state",          :null => false
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "import_source_files", ["created_at"], :name => "index_import_source_files_on_created_at"
  add_index "import_source_files", ["source_type_cd"], :name => "index_import_source_files_on_source_type_cd"
  add_index "import_source_files", ["state"], :name => "index_import_source_files_on_state"

  create_table "music_labels", :force => true do |t|
    t.string   "name",        :null => false
    t.string   "website"
    t.string   "distributor"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "music_labels", ["name"], :name => "index_music_labels_on_name", :unique => true

  create_table "practices", :force => true do |t|
    t.integer "kind_cd", :null => false
  end

  add_index "practices", ["kind_cd"], :name => "index_practices_on_kind_cd", :unique => true

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

  add_foreign_key "albums", "music_labels", :name => "albums_music_label_id_fk"

  add_foreign_key "albums_artists", "albums", :name => "albums_artists_album_id_fk"
  add_foreign_key "albums_artists", "artists", :name => "albums_artists_artist_id_fk"

  add_foreign_key "artists_practices", "artists", :name => "artists_practices_artist_id_fk"
  add_foreign_key "artists_practices", "practices", :name => "artists_practices_practice_id_fk"

  add_foreign_key "contributions", "users", :name => "contributions_whodunnit_id_fk", :column => "whodunnit_id"

  add_foreign_key "import_entries", "import_source_files", :name => "import_entries_import_source_file_id_fk"

  add_foreign_key "import_failures", "import_entries", :name => "import_failures_import_entry_id_fk"

end
