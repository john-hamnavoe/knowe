# Task to create lift events for posting into test system
# It copies selected month of events to create a new month of events
# Usage: rake create_test_lift_events
#
# Before running this task, you must check the following: 
# 1. Set the invoice_cycle_id variable to id valid for your target system
# 2. Set the month to target month (if you have more than 1 year data you will need to change query to handle year)
# 3. Set the add_months variable to number of months to add to target month
# 4. Set the project_id variable to your project id
# 5. Set the vehicle_id variable to your vehicle or sample vehicle from PlatformVehicle

task :create_test_lift_events => :environment do
  project_id = 1
  invoice_cycle_id = 6
  month = 3
  add_months = 5
  vehicle_id = 67

  project = Project.find(project_id)

  lift_events = PlatformLiftEvent.joins(platform_order_item: [platform_order: [platform_customer_site: :platform_customer]]).where(
    "platform_customers.platform_invoice_cycle_id = ? AND EXTRACT(MONTH FROM platform_lift_events.collection_date) = ?", invoice_cycle_id, month).where(project_id: project_id)

  vehicle = PlatformVehicle.find(vehicle_id)

  lift_events.each_with_index do |lift_event, index|
    PlatformLiftEvent.create(
      project: project, 
      platform_order_item_id: lift_event.platform_order_item_id,
      platform_vehicle_id: vehicle.id,
      vehicle_code: vehicle.vehicle_code,
      collection_date: lift_event.collection_date + add_months.months,
      collection_time_stamp: lift_event.collection_time_stamp + add_months.months,
      charge_weight: lift_event.net_weight,
      net_weight: lift_event.net_weight,
      weight: lift_event.net_weight,
      tag: lift_event.tag,
      is_collected: true, 
      related_site_order_container_guid: lift_event.related_site_order_container_guid,
      lift_text: "API Test Data",
      information_text: lift_event.information_text
    )
    print "." if index % 10 == 0
  end

  post_repo = PlatformPostRepository.new(project.user, project)
  post_repo.update_row_count("PlatformLiftEvent")  
end


