# frozen_string_literal: true

class PlatformCasualCustomersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_title

  def index
    @query, page = ransack_query(PlatformCasualCustomer, "name asc")

    @pagy, @platform_customers = pagy(@query.result(distinct: true).includes(:platform_customer_state), page: page)
  end

  def show
    @customer = repo.load(params[:id])
    @selected_site = @customer.platform_customer_sites.first || PlatformCustomerSite.new
    @selected_contact = @customer.platform_contacts.first || PlatformContact.new

    @timeline =  @customer.platform_orders.map { |order| { title: order.order_number, type: "Order", date: order.process_from, content: "#{order.platform_service&.description} (#{order.platform_container_type&.description})" } }
    @timeline += @customer.platform_jobs.map { |job| { title: job.ticket_no, type: "Job", date: job.date_required, content: job.platform_action&.description } }
  end

  private

  def set_title
    @title = "Casual Customers"
    @title_path = platform_casual_customers_path
  end

  def repo
    @repo ||= PlatformCustomerRepository.new(current_user)
  end  
end
