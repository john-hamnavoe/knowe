class CreatePlatformDayOfWeeks < ActiveRecord::Migration[7.0]
  def change
    create_table :platform_day_of_weeks do |t|
      t.references :project, null: false, foreign_key: true

      t.string :day_of_week
      t.uuid :guid

      t.timestamps

      t.index [:guid, :project_id], unique: true, name: "index_platform_day_of_weeks_on_guid_project"
    end
  end
end
