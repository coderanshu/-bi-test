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

ActiveRecord::Schema.define(:version => 20130317044446) do

  create_table "alert_guideline_steps", :force => true do |t|
    t.integer  "alert_id"
    t.integer  "patient_guideline_step_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "alert_responses", :force => true do |t|
    t.integer  "alert_id"
    t.integer  "user_id"
    t.integer  "response_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "alerts", :force => true do |t|
    t.integer  "patient_id"
    t.integer  "body_system_id"
    t.integer  "alert_type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "description"
    t.integer  "severity"
    t.integer  "status"
    t.integer  "acknowledged_id"
    t.datetime "acknowledged_on"
    t.datetime "expires_on"
    t.integer  "action_on_expire"
  end

  create_table "body_systems", :force => true do |t|
    t.string   "name"
    t.integer  "order"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "guideline_steps", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "order"
    t.integer  "guideline_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "guidelines", :force => true do |t|
    t.string   "name"
    t.string   "organization"
    t.string   "url"
    t.string   "description"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "body_system_id"
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.integer  "location_type"
    t.integer  "parent_id"
    t.boolean  "can_have_patients"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "observations", :force => true do |t|
    t.string   "name"
    t.string   "value_text"
    t.integer  "value_numeric"
    t.datetime "value_timestamp"
    t.integer  "patient_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "patient_guideline_steps", :force => true do |t|
    t.integer  "patient_guideline_id"
    t.integer  "guideline_step_id"
    t.boolean  "is_met"
    t.boolean  "requires_data"
    t.integer  "status"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "patient_guidelines", :force => true do |t|
    t.integer  "guideline_id"
    t.integer  "patient_id"
    t.integer  "status"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "patient_locations", :force => true do |t|
    t.integer  "patient_id"
    t.integer  "location_id"
    t.integer  "status"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "patients", :force => true do |t|
    t.string   "source_mrn"
    t.string   "prefix"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "suffix"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "risk_profiles", :force => true do |t|
    t.integer  "patient_id"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "user_sessions", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.integer  "user_id"
    t.string   "username"
    t.string   "name"
    t.string   "email"
    t.string   "workphone"
    t.string   "cellphone"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.integer  "login_count"
    t.integer  "failed_login_count"
    t.string   "current_login_at"
    t.string   "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

end
