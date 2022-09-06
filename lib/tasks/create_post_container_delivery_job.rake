# Proof of concept task for creating container delivery job
# Scenario is we have central account to create the deliveries and will need 
# Create a new site so driver knows where to deliver
# Create a new order for each material 
# Create a new delivery job for each order item

task :create_post_container_delivery_job => :environment do
  project = Project.find(1)
  user = User.find(1)

  # Create a new site so driver knows where to deliver
  site_name = "Graham Carey"
  site_address = "5 Main Street"
  site_town = "Galway"
  site_country = "Ireland"
  site_postcode = "EC1Y 1AA"
  site_tel_no = "0123456789"


  # Constants Required to the Account we created
  platform_customer_id = 80425
  platform_company_outlet_id = 1
  platform_zone_id= 11
  platform_customer_site_state_id = 1
  platform_service_id = 21
  platform_general_waste_material_id = 3
  platform_organic_material_id = 5
  platform_mixed_recy_material_id = 4
  platform_container_type_id = 3
  platform_priority_id = 1
  platform_service_agreement_id = 429
  platform_container_status_id = 1
  platform_action_id = 21
  platform_vat_id = 1

  site = PlatformCustomerSiteRepository.new(user).create(
    {platform_customer_id: platform_customer_id,
     platform_company_outlet_id: platform_company_outlet_id,
     platform_customer_site_state_id: platform_customer_site_state_id,
     platform_zone_id: platform_zone_id,
     name: site_name,
     platform_location_attributes: {
      description: site_name,
      address_1: site_address,
      address_4: site_town,
      address_5: site_country,
      post_code: site_postcode,
      tel_no: site_tel_no,
      platform_zone_id: platform_zone_id
     }
    }
  )

  PlatformCustomerSiteAdapter.new(user, project).create(site)

  site = PlatformCustomerSite.last

  # Create a new order for each material
  order_waste = PlatformOrderRepository.new(user).create(
    { platform_customer_site_id: site.id,
      platform_company_outlet_id: platform_company_outlet_id,
      platform_service_id: platform_service_id,
      platform_material_id: platform_general_waste_material_id,
      platform_container_type_id: platform_container_type_id,
      platform_priority_id: platform_priority_id,
      platform_service_agreement_id: platform_service_agreement_id,
      process_from: Time.zone.today,
      platform_order_items_attributes: [ {
        platform_container_status_id: platform_container_status_id,
        platform_container_type_id: platform_container_type_id,
      } ]
    } )

  order_organic = PlatformOrderRepository.new(user).create(
    { platform_customer_site_id: site.id,
      platform_company_outlet_id: platform_company_outlet_id,
      platform_service_id: platform_service_id,
      platform_material_id: platform_organic_material_id,
      platform_container_type_id: platform_container_type_id,
      platform_priority_id: platform_priority_id,
      platform_service_agreement_id: platform_service_agreement_id,
      process_from: Time.zone.today,
      platform_order_items_attributes: [ {
        platform_container_status_id: platform_container_status_id,
        platform_container_type_id: platform_container_type_id,
      } ]
    } )    

  order_recy = PlatformOrderRepository.new(user).create(
    { platform_customer_site_id: site.id,
      platform_company_outlet_id: platform_company_outlet_id,
      platform_service_id: platform_service_id,
      platform_material_id: platform_mixed_recy_material_id,
      platform_container_type_id: platform_container_type_id,
      platform_priority_id: platform_priority_id,
      platform_service_agreement_id: platform_service_agreement_id,
      process_from: Time.zone.today,
      platform_order_items_attributes: [ {
        platform_container_status_id: platform_container_status_id,
        platform_container_type_id: platform_container_type_id,
      } ]
    } )  

  order_adapter = PlatformOrderAdapter.new(user, project)
  order_adapter.create(order_waste)
  order_adapter.create(order_organic)
  order_adapter.create(order_recy)  

  order_waste.platform_order_items.destroy_all
  order_organic.platform_order_items.destroy_all
  order_recy.platform_order_items.destroy_all
  
  order_adapter.fetch(order_waste.guid)
  order_adapter.fetch(order_organic.guid)
  order_adapter.fetch(order_recy.guid)    

  order_waste.reload
  order_organic.reload
  order_recy.reload

  # Create a new delivery job for each order item
  job_waste = PlatformJobRepository.new(user).create(
      { platform_action_id: platform_action_id,
        platform_company_outlet_id: platform_company_outlet_id,
        platform_order_id: order_waste.id,
        platform_container_type_id: platform_container_type_id,
        platform_material_id: platform_general_waste_material_id,
        platform_vat_id: platform_vat_id,
        platform_order_item_id: order_waste.platform_order_items.first.id,    
        date_required: Time.zone.today
      } )

  job_organic = PlatformJobRepository.new(user).create(
    { platform_action_id: platform_action_id,
      platform_company_outlet_id: platform_company_outlet_id,
      platform_order_id: order_organic.id,
      platform_container_type_id: platform_container_type_id,
      platform_material_id: platform_organic_material_id,
      platform_vat_id: platform_vat_id,
      platform_order_item_id: order_organic.platform_order_items.first.id,    
      date_required: Time.zone.today
    } )

  job_recy = PlatformJobRepository.new(user).create(
    { platform_action_id: platform_action_id,
      platform_company_outlet_id: platform_company_outlet_id,
      platform_order_id: order_recy.id,
      platform_container_type_id: platform_container_type_id,
      platform_material_id: platform_mixed_recy_material_id,
      platform_vat_id: platform_vat_id,
      platform_order_item_id: order_recy.platform_order_items.first.id,    
      date_required: Time.zone.today
    } )

  job_adapter = PlatformJobAdapter.new(user, project)
  job_adapter.create(job_waste)
  job_adapter.create(job_organic)
  job_adapter.create(job_recy)
end