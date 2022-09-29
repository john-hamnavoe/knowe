class AddNotesToPlatformCustomer < ActiveRecord::Migration[7.0]
  def change
    add_column :platform_customers, :notes, :string
  end
end
