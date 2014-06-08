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

ActiveRecord::Schema.define(:version => 20140608023806) do

  create_table "alert_guideline_steps", :force => true do |t|
    t.integer  "alert_id"
    t.integer  "patient_guideline_step_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "alert_guideline_steps", ["created_at", "updated_at"], :name => "index_alert_guideline_steps_on_created_at_and_updated_at"

  create_table "alert_responses", :force => true do |t|
    t.integer  "alert_id"
    t.integer  "user_id"
    t.integer  "response_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "alert_responses", ["created_at", "updated_at"], :name => "index_alert_responses_on_created_at_and_updated_at"

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
    t.integer  "guideline_id"
  end

  add_index "alerts", ["created_at", "updated_at"], :name => "index_alerts_on_created_at_and_updated_at"

  create_table "body_systems", :force => true do |t|
    t.string   "name"
    t.integer  "order"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "body_systems", ["created_at", "updated_at"], :name => "index_body_systems_on_created_at_and_updated_at"

  create_table "checklists", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "checklists", ["created_at", "updated_at"], :name => "index_checklists_on_created_at_and_updated_at"

  create_table "guideline_actions", :force => true do |t|
    t.integer  "guideline_id"
    t.string   "text"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "guideline_actions", ["created_at", "updated_at"], :name => "index_guideline_actions_on_created_at_and_updated_at"

  create_table "guideline_steps", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "order"
    t.integer  "guideline_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "status"
  end

  add_index "guideline_steps", ["created_at", "updated_at"], :name => "index_guideline_steps_on_created_at_and_updated_at"

  create_table "guidelines", :force => true do |t|
    t.string   "name"
    t.string   "organization"
    t.string   "url"
    t.string   "description"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "body_system_id"
    t.string   "code"
    t.string   "status"
  end

  add_index "guidelines", ["created_at", "updated_at"], :name => "index_guidelines_on_created_at_and_updated_at"

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.integer  "location_type"
    t.integer  "parent_id"
    t.boolean  "can_have_patients"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "locations", ["created_at", "updated_at"], :name => "index_locations_on_created_at_and_updated_at"

  create_table "observations", :force => true do |t|
    t.string   "name"
    t.string   "value"
    t.integer  "patient_id"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.integer  "question_id"
    t.string   "code_system"
    t.datetime "observed_on"
    t.string   "code"
    t.string   "units"
    t.integer  "patient_flowsheet_row_id"
  end

  add_index "observations", ["created_at", "updated_at"], :name => "index_observations_on_created_at_and_updated_at"

  create_table "patient_checklists", :force => true do |t|
    t.integer  "checklist_id"
    t.integer  "patient_id"
    t.datetime "date"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "patient_checklists", ["created_at", "updated_at"], :name => "index_patient_checklists_on_created_at_and_updated_at"

  create_table "patient_flowsheet_rows", :force => true do |t|
    t.integer  "patient_flowsheet_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "patient_flowsheet_rows", ["created_at", "updated_at"], :name => "index_patient_flowsheet_rows_on_created_at_and_updated_at"

  create_table "patient_flowsheets", :force => true do |t|
    t.integer  "flowsheet_id"
    t.integer  "patient_id"
    t.string   "template"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "patient_flowsheets", ["created_at", "updated_at"], :name => "index_patient_flowsheets_on_created_at_and_updated_at"

  create_table "patient_guideline_actions", :force => true do |t|
    t.integer  "patient_id"
    t.integer  "guideline_action_id"
    t.integer  "patient_guideline_id"
    t.integer  "acted_id"
    t.datetime "acted_on"
    t.string   "action"
    t.integer  "status"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.text     "details"
  end

  add_index "patient_guideline_actions", ["created_at", "updated_at"], :name => "index_patient_guideline_actions_on_created_at_and_updated_at"

  create_table "patient_guideline_steps", :force => true do |t|
    t.integer  "patient_guideline_id"
    t.integer  "guideline_step_id"
    t.boolean  "is_met"
    t.boolean  "requires_data"
    t.integer  "status"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "patient_id"
  end

  add_index "patient_guideline_steps", ["created_at", "updated_at"], :name => "index_patient_guideline_steps_on_created_at_and_updated_at"

  create_table "patient_guidelines", :force => true do |t|
    t.integer  "guideline_id"
    t.integer  "patient_id"
    t.integer  "status"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "patient_guidelines", ["created_at", "updated_at"], :name => "index_patient_guidelines_on_created_at_and_updated_at"

  create_table "patient_locations", :force => true do |t|
    t.integer  "patient_id"
    t.integer  "location_id"
    t.integer  "status"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "patient_locations", ["created_at", "updated_at"], :name => "index_patient_locations_on_created_at_and_updated_at"

  create_table "patients", :force => true do |t|
    t.string   "source_mrn"
    t.string   "prefix"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "suffix"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "gender"
  end

  add_index "patients", ["created_at", "updated_at"], :name => "index_patients_on_created_at_and_updated_at"

  create_table "problems", :force => true do |t|
    t.integer  "observation_id"
    t.string   "status"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "alert_id"
  end

  add_index "problems", ["created_at", "updated_at"], :name => "index_problems_on_created_at_and_updated_at"
  add_index "problems", ["observation_id"], :name => "index_problems_on_observation_id"

  create_table "questions", :force => true do |t|
    t.integer  "guideline_step_id"
    t.string   "code"
    t.string   "display"
    t.string   "question_type"
    t.string   "constraints"
    t.integer  "order"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "checklist_id"
  end

  add_index "questions", ["created_at", "updated_at"], :name => "index_questions_on_created_at_and_updated_at"

  create_table "responses", :force => true do |t|
    t.integer  "question_id"
    t.integer  "patient_id"
    t.string   "value"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "responses", ["created_at", "updated_at"], :name => "index_responses_on_created_at_and_updated_at"

  create_table "risk_profiles", :force => true do |t|
    t.integer  "patient_id"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "risk_profiles", ["created_at", "updated_at"], :name => "index_risk_profiles_on_created_at_and_updated_at"

  create_table "user_sessions", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_sessions", ["created_at", "updated_at"], :name => "index_user_sessions_on_created_at_and_updated_at"

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
    t.string   "display_name"
  end

  add_index "users", ["created_at", "updated_at"], :name => "index_users_on_created_at_and_updated_at"

  create_table "value_set_members", :force => true do |t|
    t.integer  "value_set_id"
    t.string   "code"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "value_set_members", ["created_at", "updated_at"], :name => "index_value_set_members_on_created_at_and_updated_at"

  create_table "value_sets", :force => true do |t|
    t.string   "code"
    t.string   "code_system"
    t.string   "name"
    t.string   "description"
    t.string   "source"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "value_sets", ["created_at", "updated_at"], :name => "index_value_sets_on_created_at_and_updated_at"

end
