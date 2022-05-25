class CreatePlatformPaymentTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :platform_payment_types do |t|
      t.references :project, null: false, foreign_key: true

      t.string :description
      t.uuid :guid
      t.boolean :is_direct_debit
      t.boolean :is_cash
      t.boolean :is_auto_pay
      t.boolean :is_card
      t.boolean :is_electronic
      t.boolean :is_cheque
      t.boolean :accept_low_value
      t.boolean :is_system_payment
      t.boolean :can_mark_as_bad
      t.boolean :is_negative
      t.boolean :is_for_lodgement
      t.string :short_code
      t.boolean :is_deleted

      t.timestamps

      t.index [:guid, :project_id], unique: true, name: "index_platform_payment_type_on_guid_project"
    end
  end
end
