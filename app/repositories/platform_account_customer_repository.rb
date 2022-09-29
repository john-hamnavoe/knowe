# frozen_string_literal: true

class PlatformAccountCustomerRepository < ApplicationRepository
  def all(args = {}, order_by = "ar_account_code", direction = "asc")
    query = PlatformAccountCustomer.where( project: project).where(args)

    query.order(order_by => direction)
  end

  def create(params)
    platform_customer = PlatformAccountCustomer.new(params)

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

  def update_container_stop_status(id, is_stoplisted)
    platform_customer = load(id)
    platform_customer.platform_order_items.each do |platform_order_item|
      next unless platform_order_item.platform_container.present?

      container = platform_order_item.platform_container
      container.is_stoplisted = is_stoplisted
      container.save

      put_repo.create({guid: container.guid, class_name: "PlatformContainer", restrict_to_attributes: "is_stoplisted"})
    end
  end

  def load(id)
    PlatformAccountCustomer.find_by(id: id,  project: project)
  end

  def load_by_guid(guid)
    PlatformAccountCustomer.find_by(guid: guid,  project: project)
  end

  def load_by_account_code(account_code)
    PlatformAccountCustomer.find_by(ar_account_code: account_code,  project: project)
  end

  def import(records)
    PlatformAccountCustomer.import records, on_duplicate_key_update: { conflict_target: [:guid, :project_id], columns: [:name, :reference, :ar_account_code, :ap_account_code, :is_internal, :platform_company_id, :notes,
                                                                                                                               :credit_limit, :platform_currency_id, :platform_customer_state_id, :platform_invoice_cycle_id,
                                                                                                                               :platform_department_id, :platform_contract_status_id, :platform_payment_type_id, :platform_payment_term_id,
                                                                                                                               :platform_invoice_frequency_id, :platform_customer_type_id, :platform_customer_template_id,
                                                                                                                               :platform_direct_debit_run_configuration_id, :bank_name, :bank_account_name, :bank_account_no,
                                                                                                                               :bank_sort_code, :bank_bic, :bank_iban] }, returning: :guid

    document_deliveries = []
    records.each do |record|
      document_delivery_ids = record.platform_customer_document_deliveries.map(&:platform_document_delivery_type_id).uniq
      document_delivery_ids.each do |document_delivery_id|
        document_delivery = { platform_customer_id: record.id,
                              platform_document_delivery_type_id: document_delivery_id }
        document_deliveries << document_delivery
      end
    end
    PlatformCustomerDocumentDelivery.import document_deliveries, on_duplicate_key_ignore: true
  end

  private 

  def put_repo
    @put_repo ||= PlatformPutRepository.new(user, project)
  end
end
