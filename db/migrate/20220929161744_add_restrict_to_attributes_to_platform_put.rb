class AddRestrictToAttributesToPlatformPut < ActiveRecord::Migration[7.0]
  def change
    add_column :platform_puts, :restrict_to_attributes, :string
  end
end
