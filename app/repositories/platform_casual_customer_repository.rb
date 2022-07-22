# frozen_string_literal: true

class PlatformCasualCustomerRepository < ApplicationRepository
  def all(args = {}, order_by = "ar_account_code", direction = "asc")
    query = PlatformCasualCustomer.where( project: project).where(args)

    query.order(order_by => direction)
  end

  def create(params)
    platform_customer = PlatformCasualCustomer.new(params)

    platform_customer.project = project
    platform_customer.platform_customer_sites.each do |platform_customer_site|
      platform_customer_site.project = project
      platform_customer_site.name = platform_customer.name if platform_customer_site.name.blank?
      platform_customer_site.reference = platform_customer.reference if platform_customer_site.reference.blank?
      platform_customer_site.platform_orders.each do |platform_order|
        platform_order.project = project
        platform_order.platform_company_outlet_id = platform_customer_site.platform_company_outlet_id if platform_order.platform_company_outlet_id.nil?
        platform_order.platform_jobs.each do |platform_job|
          platform_job.project = project
          platform_job.platform_company_outlet_id = platform_order.platform_company_outlet_id if platform_job.platform_company_outlet_id.nil?
          platform_job.platform_material_id = platform_order.platform_material_id if platform_job.platform_material_id.nil?
          platform_job.platform_container_type_id = platform_order.platform_container_type_id if platform_job.platform_container_type_id.nil?
          platform_job.date_required = platform_order.process_from if platform_job.date_required.nil?
        end
      end
    end
    platform_customer.platform_contacts.each do |platform_contact|
      platform_contact.project = project
      platform_contact.surname = platform_customer.name if platform_contact.surname.blank?
      platform_contact.tel_no = platform_customer.platform_customer_sites[0].tel_no if platform_contact.tel_no.blank?
    end
    platform_customer.platform_payments.each do |platform_payment|
      platform_payment.project = project
      platform_payment.date_received = platform_customer.platform_customer_sites[0].platform_orders[0].process_from if platform_payment.date_received.nil?
      platform_payment.date_input = platform_customer.platform_customer_sites[0].platform_orders[0].process_from if platform_payment.date_input.nil?
      platform_payment.platform_job = platform_customer.platform_customer_sites[0].platform_orders[0].platform_jobs.last if platform_payment.platform_job.nil?
    end
    platform_customer.save
    platform_customer
  end

  def load(id)
    PlatformCasualCustomer.find_by(id: id,  project: project)
  end

  def load_by_guid(guid)
    PlatformCasualCustomer.find_by(guid: guid,  project: project)
  end

  def load_by_account_code(account_code)
    PlatformCasualCustomer.find_by(ar_account_code: account_code,  project: project)
  end

  def import(records)
    PlatformCasualCustomer.import records, on_duplicate_key_update: { conflict_target: [:guid, :project_id], columns: [:name, :reference, :ar_account_code, :is_internal, :platform_company_id,
                                                                                                                       :platform_customer_state_id,  :platform_customer_type_id, :platform_currency_id,
                                                                                                                       :receive_service_updates_by_email, :receive_service_updates_by_text, :receive_marketing_updates_by_email,
                                                                                                                       :receive_marketing_updates_by_text] }, returning: :guid
  end
end
