class CreatePlatformLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :platform_locations do |t|
      t.references :project, null: false, foreign_key: true
      t.string :description
      t.string :legal_name
      t.string :unqiue_reference
      t.string :house_number
      t.string :address_1
      t.string :address_2
      t.string :address_3
      t.string :address_4
      t.string :address_5
      t.string :post_code
      t.string :tel_no
      t.references :platform_zone, null: true, foreign_key: true
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.text :last_response_body
      t.integer :last_response_code
      t.uuid :guid
  
      t.timestamps

      t.index [:guid, :project_id], unique: true, name: "index_platform_locations_on_guid_project"
    end
  end
end
