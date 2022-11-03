# frozen_string_literal: true

class PlatformCustomer < ApplicationRecord
  belongs_to :project
  belongs_to :platform_company
  belongs_to :platform_currency, optional: true
  belongs_to :platform_customer_state, optional: true
  belongs_to :platform_invoice_cycle, optional: true
  belongs_to :platform_department, optional: true
  belongs_to :platform_contract_status, optional: true
  belongs_to :platform_payment_term, optional: true
  belongs_to :platform_payment_type, optional: true
  belongs_to :platform_invoice_frequency, optional: true
  belongs_to :platform_customer_type, optional: true
  belongs_to :platform_business_type, optional: true
  belongs_to :platform_customer_template, optional: true
  belongs_to :platform_direct_debit_run_configuration, optional: true

  has_many :platform_customer_sites, dependent: :destroy
  has_many :platform_contacts, dependent: :destroy
  # has_many :platform_payments, dependent: :destroy
  has_many :platform_customer_document_deliveries, dependent: :destroy
  has_many :platform_orders, through: :platform_customer_sites
  has_many :platform_jobs, through: :platform_orders
  has_many :platform_item_rentals, through: :platform_orders
  has_many :platform_route_assignments, through: :platform_orders
  has_many :platform_order_items, through: :platform_orders
  has_many :platform_lift_events, through: :platform_orders

  accepts_nested_attributes_for :platform_customer_sites
  accepts_nested_attributes_for :platform_contacts
  # accepts_nested_attributes_for :platform_payments
end
