class AddNextPlannedDateToPlatformRouteTemplate < ActiveRecord::Migration[7.0]
  def change
    add_column :platform_route_templates, :next_planned_date, :date
  end
end
