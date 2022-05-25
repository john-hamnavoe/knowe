class CreatePlatformCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :platform_customers do |t|
      t.references :project, null: false, foreign_key: true
      t.string :name
      t.string :reference
      t.boolean :is_internal, default: false
      t.boolean :combine_charges_rebates, default: false
      t.boolean :receive_service_updates_by_email, default: false
      t.boolean :receive_service_updates_by_text, default: false
      t.boolean :receive_marketing_updates_by_email, default: false
      t.boolean :receive_marketing_updates_by_text, default: false
      t.decimal :credit_limit, precision: 18, scale: 2
      t.string :ar_account_code
      t.string :ap_account_code
      t.references :platform_company, null: false, foreign_key: true
      t.references :platform_currency, null: true, foreign_key: true
      t.references :platform_customer_state, null: true, foreign_key: true
      t.references :platform_invoice_cycle, null: true, foreign_key: true
      t.references :platform_department, null: true, foreign_key: true
      t.references :platform_contract_status, null: true, foreign_key: true
      t.references :platform_payment_type, null: true, foreign_key: true
      t.references :platform_payment_term, null: true, foreign_key: true
      t.references :platform_invoice_frequency, null: true, foreign_key: true
      t.references :platform_customer_type, null: true, foreign_key: true
      t.references :platform_business_type, null: true, foreign_key: true
      t.references :platform_customer_template, null: true, foreign_key: true
      t.references :platform_direct_debit_run_configuration, null: true, foreign_key: true, index: false
      t.string :bank_name
      t.string :bank_account_name
      t.string :bank_account_no
      t.string :bank_sort_code
      t.string :bank_bic
      t.string :bank_iban

      t.text :last_response_body
      t.integer :last_response_code
      t.uuid :guid

      t.timestamps

      # rails generated index name too long
      t.index [:platform_direct_debit_run_configuration_id], name: "index_platform_customers_on_platform_direct_debit_configuration"
      t.index [:guid, :project_id], unique: true, name: "index_platform_customers_on_guid_project"
    end
  end
end
