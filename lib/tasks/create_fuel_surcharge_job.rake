# Proof of concept task for creating a job to put a monthly fuel charge on account
# Workaround for the fact that we can't create a charge or rental from the API
# This fails because the JobService will not calculate charges for a job after completion

task :create_fuel_surcharge_job => :environment do
  project = Project.find(1)
  user = User.find(1)
  # platform_customer = PlatformCustomer.find_by(ar_account_code: 'ACC1133')
  platform_order = PlatformOrder.find_by(order_number: 'OR19229')

  # Constants Required to the create the job
  platform_company_outlet_id = 1
  platform_general_waste_material_id = 3
  platform_container_type_id = 3
  platform_action_id = 164
  platform_vat_id = 1
  related_price_guid = '7590bc55-1faa-45ad-abad-af08010d427e'
  fuel_surcharge_ex_vat = 1.0


  job_charge = PlatformJobRepository.new(user).create(
    { platform_action_id: platform_action_id,
      platform_company_outlet_id: platform_company_outlet_id,
      platform_order_id: platform_order.id,
      platform_container_type_id: platform_container_type_id,
      platform_material_id: platform_general_waste_material_id,
      platform_vat_id: platform_vat_id,
      date_required: Time.zone.today,
      related_price_guid: related_price_guid,
      override_rate: fuel_surcharge_ex_vat,
      is_external_transport: true
    } )

  job_adapter = PlatformJobAdapter.new(user, project)
  job_adapter.create(job_charge)
  job_adapter.fetch_price_override(job_charge)
  job_adapter.complete(job_charge)  
end