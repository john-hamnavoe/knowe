class AddPlatformVehicleToPlatformLiftEvent < ActiveRecord::Migration[7.0]
  def change
    add_reference :platform_lift_events, :platform_vehicle, null: true, foreign_key: true
  end
end
