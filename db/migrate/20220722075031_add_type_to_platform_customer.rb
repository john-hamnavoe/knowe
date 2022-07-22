class AddTypeToPlatformCustomer < ActiveRecord::Migration[7.0]
  def change
    add_column :platform_customers, :type, :string
  end
end
