class FixUniqueReferenceColumnName < ActiveRecord::Migration[7.0]
  def change
    rename_column :platform_locations, :unqiue_reference, :unique_reference
  end
end
