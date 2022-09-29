# frozen_string_literal: true

class PlatformAccountCustomerAdapter < ApplicationAdapter
  def create(platform_customer)
    return unless platform_customer.guid.nil?

    response = post("integrator/erp/accounting/accountCustomers", platform_customer.as_platform_account_json)
 
    if response.success?
      platform_customer.update(guid: response.data[:resource], last_response_body: response.body, last_response_code: response.code)
    else
      platform_customer.update(last_response_body: response.body, last_response_code: response.code)
    end
    response
  end

  def update(platform_customer, *attributes)
    return if platform_customer.guid.blank?

    response = put("integrator/erp/accounting/accountCustomers", platform_customer.guid, platform_customer.as_platform_account_json(*attributes))

    platform_customer.update(last_response_body: response.body, last_response_code: response.code)

    response
  end

  def fetch(guid)
    load_standing_data
    import_customer(guid)
  end

  def fetch_by_account_number(account_numbers)
    load_standing_data
    import_customers(account_numbers)
    PlatformCustomerSiteAdapter.new(user, project).fetch_by_account_number(account_numbers)
    PlatformOrderAdapter.new(user, project).fetch_by_account_number(account_numbers)
    PlatformContactAdapter.new(user, project).fetch_by_account_number(account_numbers)
  end

  def fetch_all(pages = nil)
    load_standing_data
    import_all_customers(bookmark_repo.find(PlatformBookmark::CUSTOMER_ACCOUNT), pages)
  end

  private

  def import_customer(guid)
    response = query("integrator/erp/accounting/accountCustomers/#{guid}")
    return unless response.success?

    customer_repo.import([customer_from_resource(response.data)])
  end

  def import_customers(ar_account_codes)
    records = []
    ar_account_codes.each do |ar_account_code|
      response = query_with_filter("integrator/erp/accounting/accountCustomers", "filter=ARAccountCode eq '#{ar_account_code.strip}'")
      records += customers_from_response(response.data) if response.success?
    end
    customer_repo.import(records)
  end

  def import_all_customers(bookmark, pages)
    page = 1

    loop do 
      response = query_changes("integrator/erp/accounting/accountCustomers/changes", bookmark&.until_bookmark, bookmark&.cursor_bookmark)
      customer_repo.import(customers_from_response(response.data)) if response.success?
      bookmark = bookmark_repo.create_or_update(PlatformBookmark::CUSTOMER_ACCOUNT, response.until, response.cursor)

      break if response.cursor.nil? || (pages.present? && page >= pages)

      page += 1
    end
  end

  def customers_from_response(response_data)
    records = []
    response_data[:resource].each do |customer|
      records << customer_from_resource(customer)
    end
    records
  end

  def customer_from_resource(customer)
    company_id = @companies.find { |c| c.guid == customer[:resource][:CompanyListItem][:Guid] }&.id
    currency_id = customer[:resource][:CurrencyListItem].present? ? @currencies.find { |c| c.guid == customer[:resource][:CurrencyListItem][:Guid] }&.id : nil
    customer_state_id = customer[:resource][:CustomerStateListItem].present? ? @customer_states.find { |c| c.guid == customer[:resource][:CustomerStateListItem][:Guid] }&.id : nil
    customer_type_id = customer[:resource][:CustomerTypeListItem].present? ? @customer_types.find { |c| c.guid == customer[:resource][:CustomerTypeListItem][:Guid] }&.id : nil
    invoice_cycle_id = customer[:resource][:Contract][:InvoiceCycleListItem].present? ? @invoice_cycles.find { |c| c.guid == customer[:resource][:Contract][:InvoiceCycleListItem][:Guid] }&.id : nil
    department_id = customer[:resource][:Contract][:DepartmentListItem].present? ? @departments.find { |c| c.guid == customer[:resource][:Contract][:DepartmentListItem][:Guid] }&.id : nil
    contract_status_id = customer[:resource][:Contract][:ContractStatusListItem].present? ? @contract_statuses.find { |c| c.guid == customer[:resource][:Contract][:ContractStatusListItem][:Guid] }&.id : nil
    payment_term_id = customer[:resource][:Contract][:PaymentTermListItem].present? ? @payment_terms.find { |c| c.guid == customer[:resource][:Contract][:PaymentTermListItem][:Guid] }&.id : nil
    payment_type_id = customer[:resource][:Contract][:PaymentTypeListItem].present? ? @payment_types.find { |c| c.guid == customer[:resource][:Contract][:PaymentTypeListItem][:Guid] }&.id : nil
    invoice_frequency_id = customer[:resource][:Contract][:InvoiceFrequencyTermListItem].present? ? @invoice_frequencies.find { |c| c.guid == customer[:resource][:Contract][:InvoiceFrequencyTermListItem][:Guid] }&.id : nil
    business_type_id = customer[:resource][:BusinessTypeListItem].present? ? @business_types.find { |c| c.guid == customer[:resource][:BusinessTypeListItem][:Guid] }&.id : nil
    customer_template_id = customer[:resource][:CustomerTemplateListItem].present? ? @customer_templates.find { |c| c.guid == customer[:resource][:CustomerTemplateListItem][:Guid] }&.id : nil
    platform_customer = PlatformAccountCustomer.new(project_id: project.id,
                                                    guid: customer[:resource][:GUID],
                                                    name: customer[:resource][:Name],
                                                    is_internal: customer[:resource][:IsInternal],
                                                    reference: customer[:resource][:Reference],
                                                    ar_account_code: customer[:resource][:ARAccountCode],
                                                    ap_account_code: customer[:resource][:APAccountCode],
                                                    credit_limit: customer[:resource][:Contract][:CreditLimit],
                                                    notes: customer[:resource][:Notes],
                                                    platform_company_id: company_id,
                                                    platform_currency_id: currency_id,
                                                    platform_customer_state_id: customer_state_id,
                                                    platform_invoice_cycle_id: invoice_cycle_id,
                                                    platform_department_id: department_id,
                                                    platform_contract_status_id: contract_status_id,
                                                    platform_payment_type_id: payment_type_id,
                                                    platform_payment_term_id: payment_term_id,
                                                    platform_invoice_frequency_id: invoice_frequency_id,
                                                    platform_customer_type_id: customer_type_id,
                                                    platform_business_type_id: business_type_id,
                                                    platform_customer_template_id: customer_template_id)
    if customer[:resource][:BankDetails].present?
      direct_debit_run_id = @direct_debit_runs.find { |c| c.guid == customer[:resource][:BankDetails][:DirectDebitRunConfigListItem][:Guid] }&.id
      platform_customer.platform_direct_debit_run_configuration_id = direct_debit_run_id
      platform_customer.bank_name = customer[:resource][:BankDetails][:BankName]
      platform_customer.bank_account_name = customer[:resource][:BankDetails][:AccountName]
      platform_customer.bank_account_no = customer[:resource][:BankDetails][:AccountNo]
      platform_customer.bank_sort_code = customer[:resource][:BankDetails][:SortCode]
      platform_customer.bank_bic = customer[:resource][:BankDetails][:BIC]
      platform_customer.bank_iban = customer[:resource][:BankDetails][:IBAN]
    end

    return platform_customer if customer[:resource][:Contract][:InvoiceDocumentDeliveryMethods].blank?

    customer[:resource][:Contract][:InvoiceDocumentDeliveryMethods].each do |document_delivery_method|
      document_delivery_type_id = @document_delivery_types.find { |c| c.guid == document_delivery_method[:DocumentDeliveryType][:Guid] }&.id
      platform_customer.platform_customer_document_deliveries.build(platform_document_delivery_type_id: document_delivery_type_id)
    end

    platform_customer
  end

  def company_repo
    @company_repo ||= PlatformCompanyRepository.new(user, project)
  end

  def customer_repo
    @customer_repo ||= PlatformAccountCustomerRepository.new(user, project)
  end

  def bookmark_repo
    @bookmark_repo ||= PlatformBookmarkRepository.new(user, project)
  end

  def load_standing_data
    @companies = company_repo.all
    @departments = PlatformDepartmentRepository.new(user, project).all
    @invoice_cycles = PlatformInvoiceCycleRepository.new(user, project).all
    @invoice_frequencies = PlatformInvoiceFrequencyRepository.new(user, project).all
    @currencies = PlatformCurrencyRepository.new(user, project).all
    @invoice_frequencies = PlatformInvoiceFrequencyRepository.new(user, project).all
    @customer_states = PlatformCustomerStateRepository.new(user, project).all
    @customer_types = PlatformCustomerTypeRepository.new(user, project).all
    @contract_statuses = PlatformContractStatusRepository.new(user, project).all
    @payment_terms = PlatformPaymentTermRepository.new(user, project).all
    @payment_types = PlatformPaymentTypeRepository.new(user, project).all
    @business_types = PlatformBusinessTypeRepository.new(user, project).all
    @customer_templates = PlatformCustomerTemplateRepository.new(user, project).all
    @document_delivery_types = PlatformDocumentDeliveryTypeRepository.new(user, project).all
    @direct_debit_runs = PlatformDirectDebitRunConfigurationRepository.new(user, project).all
  end
end
