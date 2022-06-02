class AddLastResponsesToLiftEvent < ActiveRecord::Migration[7.0]
  def change
    add_column :platform_lift_events, :last_response_body, :text
    add_column :platform_lift_events, :last_response_code, :integer
  end
end
