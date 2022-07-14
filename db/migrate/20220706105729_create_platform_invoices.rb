class CreatePlatformInvoices < ActiveRecord::Migration[7.0]
  def change
    create_table :platform_invoices do |t|
      t.references :project, null: false, foreign_key: true
      t.references :platform_customer, null: true, foreign_key: true
      t.string :invoice_number
      t.string :customer_invoice_number
      t.references :platform_invoice_cycle, null: true, foreign_key: true
      t.references :platform_company_outlet, null: true, foreign_key: true
      t.references :platform_department, null: true, foreign_key: true
      t.references :platform_accounting_period, null: true, foreign_key: true
      t.boolean :is_cash
      t.boolean :is_accepted
      t.boolean :is_debit
      t.boolean :is_rebilled
      t.boolean :is_tax_adjustment
      t.boolean :is_request_for_payment
      t.date :input_date
      t.date :invoice_date
      t.date :due_date
      t.decimal :amount
      t.decimal :base_amount
      t.references :platform_location, null: true, foreign_key: true
      t.string :print_house_number
      t.string :print_address_1
      t.string :print_address_2
      t.string :print_address_3
      t.string :print_address_4
      t.string :print_address_5
      t.string :print_postcode
      t.string :notes
      t.uuid :batch_guid
      t.uuid :guid

      t.timestamps

      t.index [:guid, :project_id], unique: true, name: "index_platform_invoices_on_guid_project"
    end
  end
end
