class PlatformInvoice < ApplicationRecord
  belongs_to :project
  belongs_to :platform_customer, optional: true
  belongs_to :platform_invoice_cycle, optional: true
  belongs_to :platform_company_outlet, optional: true
  belongs_to :platform_department, optional: true
  belongs_to :platform_accounting_period, optional: true
  belongs_to :platform_location, optional: true
end
