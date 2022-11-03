class AddScheduleToPlatformJob < ActiveRecord::Migration[7.0]
  def change
    add_column :platform_jobs, :related_schedule_guid, :uuid
    add_reference :platform_jobs, :platform_schedule, null: true, foreign_key: true
  end
end
