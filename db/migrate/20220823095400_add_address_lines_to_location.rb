class AddAddressLinesToLocation < ActiveRecord::Migration[7.0]
  def change
    add_column :platform_locations, :address_6, :string
    add_column :platform_locations, :address_7, :string
    add_column :platform_locations, :address_8, :string
    add_column :platform_locations, :address_9, :string
  end
end
