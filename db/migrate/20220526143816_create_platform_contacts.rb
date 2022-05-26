class CreatePlatformContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :platform_contacts do |t|
      t.references :project, null: false, foreign_key: true
      t.string :forename
      t.string :surname
      t.string :tel_no
      t.string :email
      t.references :platform_customer, null: false, foreign_key: true
      t.references :platform_contact_type, null: false, foreign_key: true
      t.text :last_response_body
      t.integer :last_response_code
      t.uuid :guid

      t.timestamps

      t.index [:guid, :project_id], unique: true, name: "index_platform_contact_on_guid_project"
    end
  end
end
