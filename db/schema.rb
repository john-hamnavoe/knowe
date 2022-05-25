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

ActiveRecord::Schema[7.0].define(version: 2022_05_23_162758) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "platform_actions", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.uuid "guid"
    t.string "description"
    t.string "analysis_code"
    t.boolean "is_deleted"
    t.string "short_action"
    t.decimal "equivalent_haul", precision: 18, scale: 4
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_actions_on_guid_project", unique: true
    t.index ["project_id"], name: "index_platform_actions_on_project_id"
  end

  create_table "platform_bookmarks", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "table_name"
    t.string "until_bookmark"
    t.string "cursor_bookmark"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_platform_bookmarks_on_project_id"
  end

  create_table "platform_business_types", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "description"
    t.boolean "is_deleted"
    t.uuid "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_business_type_on_guid_project", unique: true
    t.index ["project_id"], name: "index_platform_business_types_on_project_id"
  end

  create_table "platform_companies", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "description"
    t.string "analysis_code"
    t.boolean "is_deleted"
    t.uuid "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_companies_on_guid_project", unique: true
    t.index ["project_id"], name: "index_platform_companies_on_project_id"
  end

  create_table "platform_company_outlets", force: :cascade do |t|
    t.bigint "platform_company_id", null: false
    t.bigint "project_id", null: false
    t.string "description"
    t.string "abbreviated_description"
    t.boolean "is_deleted"
    t.string "vat_registration_number"
    t.string "analysis_code"
    t.uuid "guid"
    t.uuid "location_guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_company_outlets_on_guid_project", unique: true
    t.index ["platform_company_id"], name: "index_platform_company_outlets_on_platform_company_id"
    t.index ["project_id"], name: "index_platform_company_outlets_on_project_id"
  end

  create_table "platform_contact_types", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "description"
    t.uuid "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_contact_type_on_guid_project", unique: true
    t.index ["project_id"], name: "index_platform_contact_types_on_project_id"
  end

  create_table "platform_container_statuses", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "description"
    t.uuid "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_container_status_on_guid_project", unique: true
    t.index ["project_id"], name: "index_platform_container_statuses_on_project_id"
  end

  create_table "platform_container_types", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "description"
    t.boolean "is_deleted"
    t.string "external_description"
    t.string "short_name"
    t.string "analysis_code"
    t.decimal "size", precision: 18, scale: 4
    t.decimal "tare_weight", precision: 18, scale: 4
    t.uuid "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_container_types_on_guid_project", unique: true
    t.index ["project_id"], name: "index_platform_container_types_on_project_id"
  end

  create_table "platform_contract_statuses", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "description"
    t.boolean "is_deleted"
    t.uuid "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_contract_status_on_guid_project", unique: true
    t.index ["project_id"], name: "index_platform_contract_statuses_on_project_id"
  end

  create_table "platform_currencies", force: :cascade do |t|
    t.uuid "guid"
    t.string "description"
    t.string "symbol"
    t.string "integration_code"
    t.boolean "is_deleted"
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_currencies_on_guid_project", unique: true
    t.index ["project_id"], name: "index_platform_currencies_on_project_id"
  end

  create_table "platform_customer_site_states", force: :cascade do |t|
    t.uuid "guid"
    t.string "description"
    t.boolean "is_deleted"
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_customer_site_state_on_guid_project", unique: true
    t.index ["project_id"], name: "index_platform_customer_site_states_on_project_id"
  end

  create_table "platform_customer_states", force: :cascade do |t|
    t.uuid "guid"
    t.string "description"
    t.boolean "is_deleted"
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_customer_states_on_guid_project", unique: true
    t.index ["project_id"], name: "index_platform_customer_states_on_project_id"
  end

  create_table "platform_customer_templates", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "description"
    t.boolean "is_deleted"
    t.uuid "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_customer_template_on_guid_project", unique: true
    t.index ["project_id"], name: "index_platform_customer_templates_on_project_id"
  end

  create_table "platform_customer_types", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "description"
    t.boolean "is_deleted"
    t.uuid "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_customer_type_on_guid_project", unique: true
    t.index ["project_id"], name: "index_platform_customer_types_on_project_id"
  end

  create_table "platform_day_of_weeks", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "day_of_week"
    t.uuid "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_day_of_weeks_on_guid_project", unique: true
    t.index ["project_id"], name: "index_platform_day_of_weeks_on_project_id"
  end

  create_table "platform_departments", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "description"
    t.boolean "is_deleted"
    t.uuid "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_department_on_guid_project", unique: true
    t.index ["project_id"], name: "index_platform_departments_on_project_id"
  end

  create_table "platform_direct_debit_run_configurations", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "description"
    t.boolean "is_deleted"
    t.uuid "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_direct_debit_configuration_on_guid_project", unique: true
    t.index ["project_id"], name: "index_platform_direct_debit_run_configurations_on_project_id"
  end

  create_table "platform_document_delivery_types", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "description"
    t.boolean "is_active"
    t.uuid "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_document_delivery_on_guid_project", unique: true
    t.index ["project_id"], name: "index_platform_document_delivery_types_on_project_id"
  end

  create_table "platform_external_vehicles", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "registration"
    t.string "description"
    t.uuid "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_external_vehicles_on_guid_project", unique: true
    t.index ["project_id"], name: "index_platform_external_vehicles_on_project_id"
  end

  create_table "platform_invoice_cycles", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "description"
    t.boolean "is_deleted"
    t.uuid "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_invoice_cycle_on_guid_project", unique: true
    t.index ["project_id"], name: "index_platform_invoice_cycles_on_project_id"
  end

  create_table "platform_invoice_frequencies", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "description"
    t.boolean "is_deleted"
    t.uuid "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_invoice_frequency_on_guid_project", unique: true
    t.index ["project_id"], name: "index_platform_invoice_frequencies_on_project_id"
  end

  create_table "platform_materials", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "description"
    t.boolean "is_deleted"
    t.string "short_name"
    t.string "analysis_code"
    t.uuid "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_materials_on_guid_project", unique: true
    t.index ["project_id"], name: "index_platform_materials_on_project_id"
  end

  create_table "platform_payment_points", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "description"
    t.uuid "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_payment_point_on_guid_project", unique: true
    t.index ["project_id"], name: "index_platform_payment_points_on_project_id"
  end

  create_table "platform_payment_terms", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "description"
    t.boolean "is_deleted"
    t.uuid "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_payment_term_on_guid_project", unique: true
    t.index ["project_id"], name: "index_platform_payment_terms_on_project_id"
  end

  create_table "platform_payment_types", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "description"
    t.uuid "guid"
    t.boolean "is_direct_debit"
    t.boolean "is_cash"
    t.boolean "is_auto_pay"
    t.boolean "is_card"
    t.boolean "is_electronic"
    t.boolean "is_cheque"
    t.boolean "accept_low_value"
    t.boolean "is_system_payment"
    t.boolean "can_mark_as_bad"
    t.boolean "is_negative"
    t.boolean "is_for_lodgement"
    t.string "short_code"
    t.boolean "is_deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_payment_type_on_guid_project", unique: true
    t.index ["project_id"], name: "index_platform_payment_types_on_project_id"
  end

  create_table "platform_pickup_intervals", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "description"
    t.uuid "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_pickup_intervals_on_guid_project", unique: true
    t.index ["project_id"], name: "index_platform_pickup_intervals_on_project_id"
  end

  create_table "platform_prices", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "description"
    t.bigint "platform_service_agreement_id", null: false
    t.bigint "platform_service_id"
    t.bigint "platform_action_id"
    t.bigint "platform_container_type_id"
    t.bigint "platform_material_id"
    t.decimal "amount", precision: 18, scale: 4
    t.date "effective_from"
    t.date "effective_to"
    t.uuid "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_prices_on_guid_project", unique: true
    t.index ["platform_action_id"], name: "index_platform_prices_on_platform_action_id"
    t.index ["platform_container_type_id"], name: "index_platform_prices_on_platform_container_type_id"
    t.index ["platform_material_id"], name: "index_platform_prices_on_platform_material_id"
    t.index ["platform_service_agreement_id"], name: "index_platform_prices_on_platform_service_agreement_id"
    t.index ["platform_service_id"], name: "index_platform_prices_on_platform_service_id"
    t.index ["project_id"], name: "index_platform_prices_on_project_id"
  end

  create_table "platform_priorities", force: :cascade do |t|
    t.uuid "guid"
    t.string "description"
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_priorities_on_guid_project", unique: true
    t.index ["project_id"], name: "index_platform_priorities_on_project_id"
  end

  create_table "platform_route_templates", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "platform_company_outlet_id", null: false
    t.string "description"
    t.integer "route_no"
    t.boolean "is_deleted"
    t.uuid "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_route_template_on_guid_project", unique: true
    t.index ["platform_company_outlet_id"], name: "index_platform_route_templates_on_platform_company_outlet_id"
    t.index ["project_id"], name: "index_platform_route_templates_on_project_id"
  end

  create_table "platform_service_agreements", force: :cascade do |t|
    t.uuid "guid"
    t.string "description"
    t.bigint "platform_company_outlet_id", null: false
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_service_agreements_on_guid_project", unique: true
    t.index ["platform_company_outlet_id"], name: "index_platform_service_agreements_on_platform_company_outlet_id"
    t.index ["project_id"], name: "index_platform_service_agreements_on_project_id"
  end

  create_table "platform_services", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "description"
    t.boolean "is_deleted"
    t.string "external_description"
    t.string "short_name"
    t.string "analysis_code"
    t.uuid "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_services_on_guid_project", unique: true
    t.index ["project_id"], name: "index_platform_services_on_project_id"
  end

  create_table "platform_vats", force: :cascade do |t|
    t.uuid "guid"
    t.string "description"
    t.decimal "rate", precision: 18, scale: 4
    t.boolean "is_deleted"
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_vats_on_guid_project", unique: true
    t.index ["project_id"], name: "index_platform_vats_on_project_id"
  end

  create_table "platform_weighing_types", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.uuid "guid"
    t.string "description"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_weighing_types_on_guid_project", unique: true
    t.index ["project_id"], name: "index_platform_weighing_types_on_project_id"
  end

  create_table "platform_zones", force: :cascade do |t|
    t.uuid "guid"
    t.string "description"
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_zones_on_guid_project", unique: true
    t.index ["project_id"], name: "index_platform_zones_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.boolean "active"
    t.string "base_url"
    t.string "pat_token"
    t.string "auth_cookie"
    t.integer "expiry_minutes"
    t.datetime "auth_cookie_updated_at"
    t.string "version"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "current_project_id"
    t.index ["current_project_id"], name: "index_users_on_current_project_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "platform_actions", "projects"
  add_foreign_key "platform_bookmarks", "projects"
  add_foreign_key "platform_business_types", "projects"
  add_foreign_key "platform_companies", "projects"
  add_foreign_key "platform_company_outlets", "platform_companies"
  add_foreign_key "platform_company_outlets", "projects"
  add_foreign_key "platform_contact_types", "projects"
  add_foreign_key "platform_container_statuses", "projects"
  add_foreign_key "platform_container_types", "projects"
  add_foreign_key "platform_contract_statuses", "projects"
  add_foreign_key "platform_currencies", "projects"
  add_foreign_key "platform_customer_site_states", "projects"
  add_foreign_key "platform_customer_states", "projects"
  add_foreign_key "platform_customer_templates", "projects"
  add_foreign_key "platform_customer_types", "projects"
  add_foreign_key "platform_day_of_weeks", "projects"
  add_foreign_key "platform_departments", "projects"
  add_foreign_key "platform_direct_debit_run_configurations", "projects"
  add_foreign_key "platform_document_delivery_types", "projects"
  add_foreign_key "platform_external_vehicles", "projects"
  add_foreign_key "platform_invoice_cycles", "projects"
  add_foreign_key "platform_invoice_frequencies", "projects"
  add_foreign_key "platform_materials", "projects"
  add_foreign_key "platform_payment_points", "projects"
  add_foreign_key "platform_payment_terms", "projects"
  add_foreign_key "platform_payment_types", "projects"
  add_foreign_key "platform_pickup_intervals", "projects"
  add_foreign_key "platform_prices", "platform_actions"
  add_foreign_key "platform_prices", "platform_container_types"
  add_foreign_key "platform_prices", "platform_materials"
  add_foreign_key "platform_prices", "platform_service_agreements"
  add_foreign_key "platform_prices", "platform_services"
  add_foreign_key "platform_prices", "projects"
  add_foreign_key "platform_priorities", "projects"
  add_foreign_key "platform_route_templates", "platform_company_outlets"
  add_foreign_key "platform_route_templates", "projects"
  add_foreign_key "platform_service_agreements", "platform_company_outlets"
  add_foreign_key "platform_service_agreements", "projects"
  add_foreign_key "platform_services", "projects"
  add_foreign_key "platform_vats", "projects"
  add_foreign_key "platform_weighing_types", "projects"
  add_foreign_key "platform_zones", "projects"
  add_foreign_key "projects", "users"
  add_foreign_key "users", "projects", column: "current_project_id"
end
