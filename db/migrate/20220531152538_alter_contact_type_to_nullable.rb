class AlterContactTypeToNullable < ActiveRecord::Migration[7.0]
  def change
    change_column_null :platform_contacts, :platform_contact_type_id, true
  end
end
