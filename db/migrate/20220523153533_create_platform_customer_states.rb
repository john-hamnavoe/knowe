class CreatePlatformCustomerStates < ActiveRecord::Migration[7.0]
  def change
    create_table :platform_customer_states do |t|
      t.uuid :guid
      t.string :description
      t.boolean :is_deleted
      t.references :project, null: false, foreign_key: true


      t.timestamps

      t.index [:guid, :project_id], unique: true, name: "index_platform_customer_states_on_guid_project"        
    end
  end
end
