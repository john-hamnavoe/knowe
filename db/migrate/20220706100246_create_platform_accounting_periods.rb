class CreatePlatformAccountingPeriods < ActiveRecord::Migration[7.0]
  def change
    create_table :platform_accounting_periods do |t|
      t.references :project, null: false, foreign_key: true
      t.string :description
      t.boolean :is_closed
      t.date :start_date
      t.date :end_date
      t.uuid :guid

      t.timestamps

      t.index [:guid, :project_id], unique: true, name: "index_platform_accounting_periods_on_guid_project"
    end
  end
end
