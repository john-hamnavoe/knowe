class CreatePlatformNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :platform_notifications do |t|
      t.references :project, null: false, foreign_key: true
      t.datetime :generated_time_stamp
      t.boolean :is_sent
      t.string :subject
      t.string :message
      t.string :destination_address
      t.string :notification_class
      t.uuid :guid

      t.timestamps

      t.index [:guid, :project_id], unique: true, name: "index_platform_notifications_on_guid_project"
    end
  end
end
