class CreatePlatformCustomerDocumentDeliveries < ActiveRecord::Migration[7.0]
  def change
    create_table :platform_customer_document_deliveries do |t|
      t.references :platform_customer, null: false, foreign_key: true, index: false
      t.references :platform_document_delivery_type, null: false, foreign_key: true, index: false

      t.timestamps

      # rails generated index name too long
      t.index [:platform_customer_id], name: "index_platform_customers_on_platform_document_delivery"
      t.index [:platform_document_delivery_type_id], name: "index_platform_customers_on_platform_document_delivery_type"
      t.index [:platform_customer_id, :platform_document_delivery_type_id], unique: true, name: "index_platform_customer_document_deliveries_on_unquie"
    end
  end
end
