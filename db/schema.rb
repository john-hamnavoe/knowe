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

ActiveRecord::Schema[7.0].define(version: 2023_02_08_124915) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "platform_accounting_periods", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "description"
    t.boolean "is_closed"
    t.date "start_date"
    t.date "end_date"
    t.uuid "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_accounting_periods_on_guid_project", unique: true
    t.index ["project_id"], name: "index_platform_accounting_periods_on_project_id"
  end

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
    t.integer "page"
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

  create_table "platform_contacts", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "forename"
    t.string "surname"
    t.string "tel_no"
    t.string "email"
    t.bigint "platform_customer_id", null: false
    t.bigint "platform_contact_type_id"
    t.text "last_response_body"
    t.integer "last_response_code"
    t.uuid "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_contact_on_guid_project", unique: true
    t.index ["platform_contact_type_id"], name: "index_platform_contacts_on_platform_contact_type_id"
    t.index ["platform_customer_id"], name: "index_platform_contacts_on_platform_customer_id"
    t.index ["project_id"], name: "index_platform_contacts_on_project_id"
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

  create_table "platform_containers", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "tag"
    t.string "serial_no"
    t.string "note"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.boolean "is_stoplisted"
    t.boolean "is_commercial"
    t.bigint "platform_container_status_id"
    t.bigint "platform_container_type_id", null: false
    t.bigint "platform_company_outlet_id"
    t.text "last_response_body"
    t.integer "last_response_code"
    t.uuid "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_containers_on_guid_project", unique: true
    t.index ["platform_company_outlet_id"], name: "index_platform_containers_on_platform_company_outlet_id"
    t.index ["platform_container_status_id"], name: "index_platform_containers_on_platform_container_status_id"
    t.index ["platform_container_type_id"], name: "index_platform_containers_on_platform_container_type_id"
    t.index ["project_id"], name: "index_platform_containers_on_project_id"
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

  create_table "platform_customer_document_deliveries", force: :cascade do |t|
    t.bigint "platform_customer_id", null: false
    t.bigint "platform_document_delivery_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["platform_customer_id", "platform_document_delivery_type_id"], name: "index_platform_customer_document_deliveries_on_unquie", unique: true
    t.index ["platform_customer_id"], name: "index_platform_customers_on_platform_document_delivery"
    t.index ["platform_document_delivery_type_id"], name: "index_platform_customers_on_platform_document_delivery_type"
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

  create_table "platform_customer_sites", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "name"
    t.string "reference"
    t.string "unqiue_customer_site_code"
    t.bigint "platform_customer_id", null: false
    t.bigint "platform_company_outlet_id", null: false
    t.bigint "platform_customer_site_state_id"
    t.bigint "platform_zone_id"
    t.bigint "platform_location_id"
    t.bigint "platform_invoice_location_id"
    t.text "last_response_body"
    t.integer "last_response_code"
    t.uuid "guid"
    t.uuid "location_guid"
    t.uuid "location_invoice_guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_customer_sites_on_guid_project", unique: true
    t.index ["platform_company_outlet_id"], name: "index_platform_customer_sites_on_platform_company_outlet_id"
    t.index ["platform_customer_id"], name: "index_platform_customer_sites_on_platform_customer_id"
    t.index ["platform_customer_site_state_id"], name: "index_platform_customer_sites_on_platform_customer_site_state"
    t.index ["platform_invoice_location_id"], name: "index_platform_customer_sites_on_platform_invoice_location_id"
    t.index ["platform_location_id"], name: "index_platform_customer_sites_on_platform_location_id"
    t.index ["platform_zone_id"], name: "index_platform_customer_sites_on_platform_zone_id"
    t.index ["project_id"], name: "index_platform_customer_sites_on_project_id"
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

  create_table "platform_customers", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "name"
    t.string "reference"
    t.boolean "is_internal", default: false
    t.boolean "combine_charges_rebates", default: false
    t.boolean "receive_service_updates_by_email", default: false
    t.boolean "receive_service_updates_by_text", default: false
    t.boolean "receive_marketing_updates_by_email", default: false
    t.boolean "receive_marketing_updates_by_text", default: false
    t.decimal "credit_limit", precision: 18, scale: 2
    t.string "ar_account_code"
    t.string "ap_account_code"
    t.bigint "platform_company_id", null: false
    t.bigint "platform_currency_id"
    t.bigint "platform_customer_state_id"
    t.bigint "platform_invoice_cycle_id"
    t.bigint "platform_department_id"
    t.bigint "platform_contract_status_id"
    t.bigint "platform_payment_type_id"
    t.bigint "platform_payment_term_id"
    t.bigint "platform_invoice_frequency_id"
    t.bigint "platform_customer_type_id"
    t.bigint "platform_business_type_id"
    t.bigint "platform_customer_template_id"
    t.bigint "platform_direct_debit_run_configuration_id"
    t.string "bank_name"
    t.string "bank_account_name"
    t.string "bank_account_no"
    t.string "bank_sort_code"
    t.string "bank_bic"
    t.string "bank_iban"
    t.text "last_response_body"
    t.integer "last_response_code"
    t.uuid "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.string "notes"
    t.index ["guid", "project_id"], name: "index_platform_customers_on_guid_project", unique: true
    t.index ["platform_business_type_id"], name: "index_platform_customers_on_platform_business_type_id"
    t.index ["platform_company_id"], name: "index_platform_customers_on_platform_company_id"
    t.index ["platform_contract_status_id"], name: "index_platform_customers_on_platform_contract_status_id"
    t.index ["platform_currency_id"], name: "index_platform_customers_on_platform_currency_id"
    t.index ["platform_customer_state_id"], name: "index_platform_customers_on_platform_customer_state_id"
    t.index ["platform_customer_template_id"], name: "index_platform_customers_on_platform_customer_template_id"
    t.index ["platform_customer_type_id"], name: "index_platform_customers_on_platform_customer_type_id"
    t.index ["platform_department_id"], name: "index_platform_customers_on_platform_department_id"
    t.index ["platform_direct_debit_run_configuration_id"], name: "index_platform_customers_on_platform_direct_debit_configuration"
    t.index ["platform_invoice_cycle_id"], name: "index_platform_customers_on_platform_invoice_cycle_id"
    t.index ["platform_invoice_frequency_id"], name: "index_platform_customers_on_platform_invoice_frequency_id"
    t.index ["platform_payment_term_id"], name: "index_platform_customers_on_platform_payment_term_id"
    t.index ["platform_payment_type_id"], name: "index_platform_customers_on_platform_payment_type_id"
    t.index ["project_id"], name: "index_platform_customers_on_project_id"
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

  create_table "platform_default_actions", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.uuid "platform_action_guid"
    t.string "platform_action_description"
    t.uuid "platform_service_guid"
    t.string "platform_service_description"
    t.uuid "platform_vat_guid"
    t.string "platform_vat_description"
    t.uuid "platform_pricing_basis_guid"
    t.string "platform_pricing_basis_description"
    t.uuid "platform_uom_guid"
    t.string "platform_uom_description"
    t.uuid "platform_material_class_guid"
    t.string "platform_material_class_description"
    t.uuid "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_default_actions_on_guid_project", unique: true
    t.index ["project_id"], name: "index_platform_default_actions_on_project_id"
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

  create_table "platform_invoices", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "platform_customer_id"
    t.string "invoice_number"
    t.string "customer_invoice_number"
    t.bigint "platform_invoice_cycle_id"
    t.bigint "platform_company_outlet_id"
    t.bigint "platform_department_id"
    t.bigint "platform_accounting_period_id"
    t.boolean "is_cash"
    t.boolean "is_accepted"
    t.boolean "is_debit"
    t.boolean "is_rebilled"
    t.boolean "is_tax_adjustment"
    t.boolean "is_request_for_payment"
    t.date "input_date"
    t.date "invoice_date"
    t.date "due_date"
    t.decimal "amount"
    t.decimal "base_amount"
    t.bigint "platform_location_id"
    t.string "print_house_number"
    t.string "print_address_1"
    t.string "print_address_2"
    t.string "print_address_3"
    t.string "print_address_4"
    t.string "print_address_5"
    t.string "print_postcode"
    t.string "notes"
    t.uuid "batch_guid"
    t.uuid "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_invoices_on_guid_project", unique: true
    t.index ["platform_accounting_period_id"], name: "index_platform_invoices_on_platform_accounting_period_id"
    t.index ["platform_company_outlet_id"], name: "index_platform_invoices_on_platform_company_outlet_id"
    t.index ["platform_customer_id"], name: "index_platform_invoices_on_platform_customer_id"
    t.index ["platform_department_id"], name: "index_platform_invoices_on_platform_department_id"
    t.index ["platform_invoice_cycle_id"], name: "index_platform_invoices_on_platform_invoice_cycle_id"
    t.index ["platform_location_id"], name: "index_platform_invoices_on_platform_location_id"
    t.index ["project_id"], name: "index_platform_invoices_on_project_id"
  end

  create_table "platform_item_rentals", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "platform_order_id", null: false
    t.integer "quantity"
    t.date "start_date"
    t.bigint "platform_price_id"
    t.bigint "platform_action_id"
    t.bigint "platform_container_type_id"
    t.boolean "is_arrears"
    t.uuid "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_item_rentals_on_guid_project", unique: true
    t.index ["platform_action_id"], name: "index_platform_item_rentals_on_platform_action_id"
    t.index ["platform_container_type_id"], name: "index_platform_item_rentals_on_platform_container_type_id"
    t.index ["platform_order_id"], name: "index_platform_item_rentals_on_platform_order_id"
    t.index ["platform_price_id"], name: "index_platform_item_rentals_on_platform_price_id"
    t.index ["project_id"], name: "index_platform_item_rentals_on_project_id"
  end

  create_table "platform_jobs", force: :cascade do |t|
    t.boolean "delete_route_assignments_on_completion", default: false
    t.boolean "in_progress", default: false
    t.boolean "is_adhoc", default: false
    t.boolean "is_completed", default: false
    t.boolean "is_confirmed", default: false
    t.boolean "is_external_transport", default: false
    t.boolean "is_financially_confirmed", default: false
    t.boolean "is_hazardous_paperwork_complete", default: false
    t.boolean "is_scheduled_transfer", default: false
    t.boolean "is_warranty", default: false
    t.uuid "related_site_order_guid"
    t.bigint "platform_action_id", null: false
    t.bigint "platform_company_outlet_id", null: false
    t.bigint "platform_order_id"
    t.bigint "platform_container_type_id"
    t.bigint "platform_material_id"
    t.bigint "platform_vat_id"
    t.bigint "platform_order_item_id"
    t.string "customer_order_no"
    t.date "date_required"
    t.string "ticket_no"
    t.string "hazardous_load_reference"
    t.string "manual_ticket_no"
    t.string "notes"
    t.string "po_number"
    t.decimal "quantity", precision: 18, scale: 4
    t.uuid "related_location_destination_guid"
    t.uuid "price_override_guid"
    t.uuid "related_price_guid"
    t.decimal "override_rate", precision: 18, scale: 4
    t.bigint "project_id", null: false
    t.uuid "guid"
    t.text "last_response_body"
    t.integer "last_response_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "related_schedule_guid"
    t.bigint "platform_schedule_id"
    t.index ["guid", "project_id"], name: "index_platform_jobs_on_guid_project", unique: true
    t.index ["platform_action_id"], name: "index_platform_jobs_on_platform_action_id"
    t.index ["platform_company_outlet_id"], name: "index_platform_jobs_on_platform_company_outlet_id"
    t.index ["platform_container_type_id"], name: "index_platform_jobs_on_platform_container_type_id"
    t.index ["platform_material_id"], name: "index_platform_jobs_on_platform_material_id"
    t.index ["platform_order_id"], name: "index_platform_jobs_on_platform_order_id"
    t.index ["platform_order_item_id"], name: "index_platform_jobs_on_platform_order_item_id"
    t.index ["platform_schedule_id"], name: "index_platform_jobs_on_platform_schedule_id"
    t.index ["platform_vat_id"], name: "index_platform_jobs_on_platform_vat_id"
    t.index ["project_id"], name: "index_platform_jobs_on_project_id"
  end

  create_table "platform_lift_events", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "platform_order_item_id"
    t.decimal "charge_weight"
    t.decimal "net_weight"
    t.decimal "weight"
    t.integer "quantity_collected"
    t.string "vehicle_code"
    t.string "information_text"
    t.string "lift_text"
    t.string "problem_text"
    t.string "tag"
    t.date "collection_date"
    t.datetime "collection_time_stamp"
    t.uuid "related_route_guid"
    t.uuid "related_route_visit_guid"
    t.uuid "related_site_order_container_guid"
    t.boolean "is_deleted"
    t.boolean "is_collected"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.uuid "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "last_response_body"
    t.integer "last_response_code"
    t.bigint "platform_vehicle_id"
    t.index ["guid", "project_id"], name: "index_platform_lift_events_on_guid_project", unique: true
    t.index ["platform_order_item_id"], name: "index_platform_lift_events_on_platform_order_item_id"
    t.index ["platform_vehicle_id"], name: "index_platform_lift_events_on_platform_vehicle_id"
    t.index ["project_id"], name: "index_platform_lift_events_on_project_id"
  end

  create_table "platform_locations", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "description"
    t.string "legal_name"
    t.string "unique_reference"
    t.string "house_number"
    t.string "address_1"
    t.string "address_2"
    t.string "address_3"
    t.string "address_4"
    t.string "address_5"
    t.string "post_code"
    t.string "tel_no"
    t.bigint "platform_zone_id"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.text "last_response_body"
    t.integer "last_response_code"
    t.uuid "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "address_6"
    t.string "address_7"
    t.string "address_8"
    t.string "address_9"
    t.index ["guid", "project_id"], name: "index_platform_locations_on_guid_project", unique: true
    t.index ["platform_zone_id"], name: "index_platform_locations_on_platform_zone_id"
    t.index ["project_id"], name: "index_platform_locations_on_project_id"
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
    t.uuid "material_class_guid"
    t.string "material_class_description"
    t.index ["guid", "project_id"], name: "index_platform_materials_on_guid_project", unique: true
    t.index ["project_id"], name: "index_platform_materials_on_project_id"
  end

  create_table "platform_notifications", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.datetime "generated_time_stamp"
    t.boolean "is_sent"
    t.string "subject"
    t.string "message"
    t.string "destination_address"
    t.string "notification_class"
    t.uuid "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_notifications_on_guid_project", unique: true
    t.index ["project_id"], name: "index_platform_notifications_on_project_id"
  end

  create_table "platform_order_items", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "platform_order_id", null: false
    t.bigint "platform_container_type_id", null: false
    t.bigint "platform_container_status_id", null: false
    t.string "tag"
    t.uuid "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "related_container_guid"
    t.bigint "platform_container_id"
    t.boolean "is_deleted", default: false
    t.index ["guid", "project_id"], name: "index_platform_order_item_on_guid_project", unique: true
    t.index ["platform_container_id"], name: "index_platform_order_items_on_platform_container_id"
    t.index ["platform_container_status_id"], name: "index_platform_order_items_on_platform_container_status_id"
    t.index ["platform_container_type_id"], name: "index_platform_order_items_on_platform_container_type_id"
    t.index ["platform_order_id"], name: "index_platform_order_items_on_platform_order_id"
    t.index ["project_id"], name: "index_platform_order_items_on_project_id"
  end

  create_table "platform_orders", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "platform_customer_site_id", null: false
    t.bigint "platform_service_id", null: false
    t.bigint "platform_material_id", null: false
    t.bigint "platform_company_outlet_id", null: false
    t.bigint "platform_container_type_id"
    t.bigint "platform_service_agreement_id"
    t.bigint "platform_priority_id"
    t.string "order_number"
    t.string "customer_order_number"
    t.string "ordered_by"
    t.date "process_from"
    t.date "valid_until"
    t.text "notes"
    t.text "driver_notes"
    t.boolean "is_customer_owned_equipment", default: false
    t.uuid "related_order_combination_grouping_guid"
    t.text "last_response_body"
    t.integer "last_response_code"
    t.uuid "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "related_service_agreement_guid"
    t.index ["guid", "project_id"], name: "index_platform_orders_on_guid_project", unique: true
    t.index ["platform_company_outlet_id"], name: "index_platform_orders_on_platform_company_outlet_id"
    t.index ["platform_container_type_id"], name: "index_platform_orders_on_platform_container_type_id"
    t.index ["platform_customer_site_id"], name: "index_platform_orders_on_platform_customer_site_id"
    t.index ["platform_material_id"], name: "index_platform_orders_on_platform_material_id"
    t.index ["platform_priority_id"], name: "index_platform_orders_on_platform_priority_id"
    t.index ["platform_service_agreement_id"], name: "index_platform_orders_on_platform_service_agreement_id"
    t.index ["platform_service_id"], name: "index_platform_orders_on_platform_service_id"
    t.index ["project_id"], name: "index_platform_orders_on_project_id"
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

  create_table "platform_posts", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "class_name"
    t.integer "position"
    t.datetime "last_request"
    t.string "last_response_code"
    t.integer "rows"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_platform_posts_on_project_id"
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

  create_table "platform_puts", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "class_name"
    t.integer "last_response_code"
    t.text "last_response_body"
    t.uuid "guid"
    t.integer "failed_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "restrict_to_attributes"
    t.index ["project_id"], name: "index_platform_puts_on_project_id"
  end

  create_table "platform_route_assignments", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "platform_order_id", null: false
    t.bigint "platform_action_id"
    t.bigint "platform_pickup_interval_id"
    t.bigint "platform_day_of_week_id"
    t.bigint "platform_container_type_id"
    t.bigint "platform_route_template_id"
    t.integer "position"
    t.date "start_date"
    t.uuid "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_route_assignments_on_guid_project", unique: true
    t.index ["platform_action_id"], name: "index_platform_route_assignments_on_platform_action_id"
    t.index ["platform_container_type_id"], name: "index_platform_route_assignments_on_platform_container_type_id"
    t.index ["platform_day_of_week_id"], name: "index_platform_route_assignments_on_platform_day_of_week_id"
    t.index ["platform_order_id"], name: "index_platform_route_assignments_on_platform_order_id"
    t.index ["platform_pickup_interval_id"], name: "index_platform_route_assignments_on_platform_pickup_interval_id"
    t.index ["platform_route_template_id"], name: "index_platform_route_assignments_on_platform_route_template_id"
    t.index ["project_id"], name: "index_platform_route_assignments_on_project_id"
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
    t.date "next_planned_date"
    t.index ["guid", "project_id"], name: "index_platform_route_template_on_guid_project", unique: true
    t.index ["platform_company_outlet_id"], name: "index_platform_route_templates_on_platform_company_outlet_id"
    t.index ["project_id"], name: "index_platform_route_templates_on_project_id"
  end

  create_table "platform_schedules", force: :cascade do |t|
    t.date "scheduled_date"
    t.boolean "is_completed", default: false
    t.boolean "is_container_schedule", default: false
    t.boolean "is_for_vehicle", default: false
    t.boolean "is_manifest_completed", default: false
    t.boolean "is_manifest_exported", default: false
    t.boolean "is_manifest_exported_failed", default: false
    t.text "notes"
    t.string "description"
    t.datetime "leave_yard_time"
    t.datetime "return_yard_time"
    t.uuid "related_vehicle_guid"
    t.uuid "related_user_driver_guid"
    t.bigint "platform_vehicle_id"
    t.bigint "platform_company_outlet_id", null: false
    t.bigint "project_id", null: false
    t.uuid "guid"
    t.text "last_response_body"
    t.integer "last_response_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_schedules_on_guid_project", unique: true
    t.index ["platform_company_outlet_id"], name: "index_platform_schedules_on_platform_company_outlet_id"
    t.index ["platform_vehicle_id"], name: "index_platform_schedules_on_platform_vehicle_id"
    t.index ["project_id"], name: "index_platform_schedules_on_project_id"
  end

  create_table "platform_service_agreements", force: :cascade do |t|
    t.uuid "guid"
    t.string "description"
    t.bigint "platform_company_outlet_id", null: false
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "related_customer_guid"
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

  create_table "platform_settings", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "class_name"
    t.datetime "last_request"
    t.string "last_response_code"
    t.integer "position"
    t.integer "rows"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_platform_settings_on_project_id"
  end

  create_table "platform_sic_codes", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "description_2007"
    t.string "code_2007"
    t.string "description_2003"
    t.string "code_2003"
    t.boolean "is_deleted"
    t.uuid "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_sic_codes_on_guid_project", unique: true
    t.index ["project_id"], name: "index_platform_sic_codes_on_project_id"
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

  create_table "platform_vehicle_types", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "description"
    t.string "code"
    t.string "collection_type"
    t.boolean "is_deleted"
    t.uuid "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_vehicle_types_on_guid_project", unique: true
    t.index ["project_id"], name: "index_platform_vehicle_types_on_project_id"
  end

  create_table "platform_vehicles", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "registration_no"
    t.string "vehicle_code"
    t.bigint "platform_company_outlet_id"
    t.bigint "platform_vehicle_type_id"
    t.uuid "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid", "project_id"], name: "index_platform_vehicles_on_guid_project", unique: true
    t.index ["platform_company_outlet_id"], name: "index_platform_vehicles_on_platform_company_outlet_id"
    t.index ["platform_vehicle_type_id"], name: "index_platform_vehicles_on_platform_vehicle_type_id"
    t.index ["project_id"], name: "index_platform_vehicles_on_project_id"
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
    t.uuid "sms_third_party_key"
    t.uuid "email_third_party_key"
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

  add_foreign_key "platform_accounting_periods", "projects"
  add_foreign_key "platform_actions", "projects"
  add_foreign_key "platform_bookmarks", "projects"
  add_foreign_key "platform_business_types", "projects"
  add_foreign_key "platform_companies", "projects"
  add_foreign_key "platform_company_outlets", "platform_companies"
  add_foreign_key "platform_company_outlets", "projects"
  add_foreign_key "platform_contact_types", "projects"
  add_foreign_key "platform_contacts", "platform_contact_types"
  add_foreign_key "platform_contacts", "platform_customers"
  add_foreign_key "platform_contacts", "projects"
  add_foreign_key "platform_container_statuses", "projects"
  add_foreign_key "platform_container_types", "projects"
  add_foreign_key "platform_containers", "platform_company_outlets"
  add_foreign_key "platform_containers", "platform_container_statuses"
  add_foreign_key "platform_containers", "platform_container_types"
  add_foreign_key "platform_containers", "projects"
  add_foreign_key "platform_contract_statuses", "projects"
  add_foreign_key "platform_currencies", "projects"
  add_foreign_key "platform_customer_document_deliveries", "platform_customers"
  add_foreign_key "platform_customer_document_deliveries", "platform_document_delivery_types"
  add_foreign_key "platform_customer_site_states", "projects"
  add_foreign_key "platform_customer_sites", "platform_company_outlets"
  add_foreign_key "platform_customer_sites", "platform_customer_site_states"
  add_foreign_key "platform_customer_sites", "platform_customers"
  add_foreign_key "platform_customer_sites", "platform_locations"
  add_foreign_key "platform_customer_sites", "platform_locations", column: "platform_invoice_location_id"
  add_foreign_key "platform_customer_sites", "platform_zones"
  add_foreign_key "platform_customer_sites", "projects"
  add_foreign_key "platform_customer_states", "projects"
  add_foreign_key "platform_customer_templates", "projects"
  add_foreign_key "platform_customer_types", "projects"
  add_foreign_key "platform_customers", "platform_business_types"
  add_foreign_key "platform_customers", "platform_companies"
  add_foreign_key "platform_customers", "platform_contract_statuses"
  add_foreign_key "platform_customers", "platform_currencies"
  add_foreign_key "platform_customers", "platform_customer_states"
  add_foreign_key "platform_customers", "platform_customer_templates"
  add_foreign_key "platform_customers", "platform_customer_types"
  add_foreign_key "platform_customers", "platform_departments"
  add_foreign_key "platform_customers", "platform_direct_debit_run_configurations"
  add_foreign_key "platform_customers", "platform_invoice_cycles"
  add_foreign_key "platform_customers", "platform_invoice_frequencies"
  add_foreign_key "platform_customers", "platform_payment_terms"
  add_foreign_key "platform_customers", "platform_payment_types"
  add_foreign_key "platform_customers", "projects"
  add_foreign_key "platform_day_of_weeks", "projects"
  add_foreign_key "platform_default_actions", "projects"
  add_foreign_key "platform_departments", "projects"
  add_foreign_key "platform_direct_debit_run_configurations", "projects"
  add_foreign_key "platform_document_delivery_types", "projects"
  add_foreign_key "platform_external_vehicles", "projects"
  add_foreign_key "platform_invoice_cycles", "projects"
  add_foreign_key "platform_invoice_frequencies", "projects"
  add_foreign_key "platform_invoices", "platform_accounting_periods"
  add_foreign_key "platform_invoices", "platform_company_outlets"
  add_foreign_key "platform_invoices", "platform_customers"
  add_foreign_key "platform_invoices", "platform_departments"
  add_foreign_key "platform_invoices", "platform_invoice_cycles"
  add_foreign_key "platform_invoices", "platform_locations"
  add_foreign_key "platform_invoices", "projects"
  add_foreign_key "platform_item_rentals", "platform_actions"
  add_foreign_key "platform_item_rentals", "platform_container_types"
  add_foreign_key "platform_item_rentals", "platform_orders"
  add_foreign_key "platform_item_rentals", "platform_prices"
  add_foreign_key "platform_item_rentals", "projects"
  add_foreign_key "platform_jobs", "platform_actions"
  add_foreign_key "platform_jobs", "platform_company_outlets"
  add_foreign_key "platform_jobs", "platform_container_types"
  add_foreign_key "platform_jobs", "platform_materials"
  add_foreign_key "platform_jobs", "platform_order_items"
  add_foreign_key "platform_jobs", "platform_orders"
  add_foreign_key "platform_jobs", "platform_schedules"
  add_foreign_key "platform_jobs", "platform_vats"
  add_foreign_key "platform_jobs", "projects"
  add_foreign_key "platform_lift_events", "platform_order_items"
  add_foreign_key "platform_lift_events", "platform_vehicles"
  add_foreign_key "platform_lift_events", "projects"
  add_foreign_key "platform_locations", "platform_zones"
  add_foreign_key "platform_locations", "projects"
  add_foreign_key "platform_materials", "projects"
  add_foreign_key "platform_notifications", "projects"
  add_foreign_key "platform_order_items", "platform_container_statuses"
  add_foreign_key "platform_order_items", "platform_container_types"
  add_foreign_key "platform_order_items", "platform_orders"
  add_foreign_key "platform_order_items", "projects"
  add_foreign_key "platform_orders", "platform_company_outlets"
  add_foreign_key "platform_orders", "platform_container_types"
  add_foreign_key "platform_orders", "platform_customer_sites"
  add_foreign_key "platform_orders", "platform_materials"
  add_foreign_key "platform_orders", "platform_priorities"
  add_foreign_key "platform_orders", "platform_service_agreements"
  add_foreign_key "platform_orders", "platform_services"
  add_foreign_key "platform_orders", "projects"
  add_foreign_key "platform_payment_points", "projects"
  add_foreign_key "platform_payment_terms", "projects"
  add_foreign_key "platform_payment_types", "projects"
  add_foreign_key "platform_pickup_intervals", "projects"
  add_foreign_key "platform_posts", "projects"
  add_foreign_key "platform_prices", "platform_actions"
  add_foreign_key "platform_prices", "platform_container_types"
  add_foreign_key "platform_prices", "platform_materials"
  add_foreign_key "platform_prices", "platform_service_agreements"
  add_foreign_key "platform_prices", "platform_services"
  add_foreign_key "platform_prices", "projects"
  add_foreign_key "platform_priorities", "projects"
  add_foreign_key "platform_puts", "projects"
  add_foreign_key "platform_route_assignments", "platform_actions"
  add_foreign_key "platform_route_assignments", "platform_container_types"
  add_foreign_key "platform_route_assignments", "platform_day_of_weeks"
  add_foreign_key "platform_route_assignments", "platform_orders"
  add_foreign_key "platform_route_assignments", "platform_pickup_intervals"
  add_foreign_key "platform_route_assignments", "platform_route_templates"
  add_foreign_key "platform_route_assignments", "projects"
  add_foreign_key "platform_route_templates", "platform_company_outlets"
  add_foreign_key "platform_route_templates", "projects"
  add_foreign_key "platform_schedules", "platform_company_outlets"
  add_foreign_key "platform_schedules", "platform_vehicles"
  add_foreign_key "platform_schedules", "projects"
  add_foreign_key "platform_service_agreements", "platform_company_outlets"
  add_foreign_key "platform_service_agreements", "projects"
  add_foreign_key "platform_services", "projects"
  add_foreign_key "platform_settings", "projects"
  add_foreign_key "platform_sic_codes", "projects"
  add_foreign_key "platform_vats", "projects"
  add_foreign_key "platform_vehicle_types", "projects"
  add_foreign_key "platform_vehicles", "platform_company_outlets"
  add_foreign_key "platform_vehicles", "platform_vehicle_types"
  add_foreign_key "platform_vehicles", "projects"
  add_foreign_key "platform_weighing_types", "projects"
  add_foreign_key "platform_zones", "projects"
  add_foreign_key "projects", "users"
  add_foreign_key "users", "projects", column: "current_project_id"
end
