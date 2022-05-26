# frozen_string_literal: true

class PlatformCustomerContactsController < ApplicationController
  include CustomerConcern
  before_action :authenticate_user!
  before_action :set_customer

  def index
    @platform_contacts = @platform_customer.platform_contacts.order(:surname)
  end
end
