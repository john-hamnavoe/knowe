# Proof of concept task for creating container take back job
# Scenario is we have central account to create the take backs and will need 
# Create a new site so driver knows where to go to get bin
# Create a new order for each material (inc site order item inc container)
# Create a new take back job for each order item

task :create_post_container_take_back_job => :environment do
  project = Project.find(1)
  user = User.find(1)

  # Create a new site so driver knows where to deliver
  site_name = "Marcus Brody"
  site_address = "10 Main Street"
  site_town = "Galway"
  site_country = "Ireland"
  site_postcode = "EC1Y 1AA"
  site_tel_no = "0123456789"
  take_back_gw_serial_no = "101234"
  take_back_gw_tag = "10TAG1234"
  take_back_or_serial_no = "104321"
  take_back_or_tag = "10TAG4321"
  take_back_mr_serial_no = "102143"
  take_back_mr_tag = "10TAG2143"  

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
  platform_action_id = 23
  platform_vat_id = 1

  site = PlatformCustomerSiteRepository.new(user, project).create(
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

  # Add containers we want to take back 
  container_waste = PlatformContainerRepository.new(user, project).create(
    { tag: take_back_gw_tag,
      serial_no: take_back_gw_serial_no,
      platform_container_type_id: platform_container_type_id,
      is_stoplisted: false,
      is_commercial: false, 
      platform_company_outlet_id: platform_company_outlet_id
    }
  )

  container_organic = PlatformContainerRepository.new(user, project).create(
    { tag: take_back_or_tag,
      serial_no: take_back_or_serial_no,
      platform_container_type_id: platform_container_type_id,
      is_stoplisted: false,
      is_commercial: false, 
      platform_company_outlet_id: platform_company_outlet_id
    }
  )

  container_mixed = PlatformContainerRepository.new(user, project).create(
    { tag: take_back_mr_tag,
      serial_no: take_back_mr_serial_no,
      platform_container_type_id: platform_container_type_id,
      is_stoplisted: false,
      is_commercial: false,
      platform_company_outlet_id: platform_company_outlet_id
    }
  )

  container_adapter = PlatformContainerAdapter.new(user, project)
  container_adapter.create(container_waste)
  container_adapter.create(container_organic)
  container_adapter.create(container_mixed)  
  container_waste.reload
  container_organic.reload
  container_mixed.reload

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
        related_container_guid: container_waste.guid,
        platform_container_id: container_waste.id
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
        related_container_guid: container_organic.guid,
        platform_container_id: container_organic.id
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
        related_container_guid: container_mixed.guid,
        platform_container_id: container_mixed.id
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