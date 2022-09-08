# Proof of concept task for creating container delivery job
# Scenario is we have central account to create the deliveries and will need 
# Create a new site so driver knows where to deliver
# Create a new order for each material 
# Create a new delivery job for each order item

task :create_post_container_delivery_job_post_prod => :environment do
  project = Project.find(2)
  user = User.find(1)

  # Create a new site so driver knows where to deliver
  site_name = "Jack Carlin"
  site_address = "5 Clonard Road"
  site_area = "Crumlin"
  site_town = "Dublin"
  site_country = "Ireland"
  site_postcode = "D12 XH73"
  site_tel_no = "0123456789"


  # Constants Required to the Account we created
  platform_customer_id = 80433
  platform_company_outlet_id = 8
  platform_zone_id = 38
  platform_customer_site_state_id = 9
  platform_service_id = 75
  platform_general_waste_material_id = 81
  platform_organic_material_id = 83
  platform_mixed_recy_material_id = 82
  platform_container_type_id = 147
  platform_priority_id = 3
  platform_service_agreement_id = 650
  platform_container_status_id = 2
  platform_action_id = 185
  platform_vat_id = 7

  site = PlatformCustomerSiteRepository.new(user, project).create(
    {platform_customer_id: platform_customer_id,
     platform_company_outlet_id: platform_company_outlet_id,
     platform_customer_site_state_id: platform_customer_site_state_id,
     platform_zone_id: platform_zone_id,
     name: site_name,
     platform_location_attributes: {
      description: site_name,
      address_1: site_address,
      address_2: site_area,
      address_4: site_town,
      address_5: site_country,
      post_code: site_postcode,
      tel_no: site_tel_no,
      platform_zone_id: platform_zone_id
     }
    }
  )

  PlatformCustomerSiteAdapter.new(user, project).create(site)

  # Create a new order for each material
  order_waste = PlatformOrderRepository.new(user, project).create(
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

  order_organic = PlatformOrderRepository.new(user, project).create(
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

  order_recy = PlatformOrderRepository.new(user, project).create(
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
  job_waste = PlatformJobRepository.new(user, project).create(
      { platform_action_id: platform_action_id,
        platform_company_outlet_id: platform_company_outlet_id,
        platform_order_id: order_waste.id,
        platform_container_type_id: platform_container_type_id,
        platform_material_id: platform_general_waste_material_id,
        platform_vat_id: platform_vat_id,
        platform_order_item_id: order_waste.platform_order_items.first.id,    
        date_required: Time.zone.today
      } )

  job_organic = PlatformJobRepository.new(user, project).create(
    { platform_action_id: platform_action_id,
      platform_company_outlet_id: platform_company_outlet_id,
      platform_order_id: order_organic.id,
      platform_container_type_id: platform_container_type_id,
      platform_material_id: platform_organic_material_id,
      platform_vat_id: platform_vat_id,
      platform_order_item_id: order_organic.platform_order_items.first.id,    
      date_required: Time.zone.today
    } )

  job_recy = PlatformJobRepository.new(user, project).create(
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