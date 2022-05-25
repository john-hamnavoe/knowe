# frozen_string_literal: true

class ImportPlatformSettingsJob < ApplicationJob
  discard_on StandardError # second catch other exceptions
  queue_as :default

  def perform(user, project)
    PlatformActionAdapter.new(user, project).fetch
    PlatformBusinessTypeAdapter.new(user, project).fetch
    PlatformContactTypeAdapter.new(user, project).fetch
    PlatformContainerTypeAdapter.new(user, project).fetch
    PlatformContractStatusAdapter.new(user, project).fetch
    PlatformCurrencyAdapter.new(user, project).fetch
    PlatformCustomerSiteStateAdapter.new(user, project).fetch
    PlatformCustomerStateAdapter.new(user, project).fetch
    PlatformCustomerTemplateAdapter.new(user, project).fetch
    PlatformCustomerTypeAdapter.new(user, project).fetch
    PlatformDayOfWeekAdapter.new(user, project).fetch
    PlatformDepartmentAdapter.new(user, project).fetch
    PlatformDirectDebitRunConfigurationAdapter.new(user, project).fetch
    PlatformDocumentDeliveryTypeAdapter.new(user, project).fetch
    PlatformExternalVehicleAdapter.new(user, project).fetch
    PlatformInvoiceCycleAdapter.new(user, project).fetch
    PlatformInvoiceFrequencyAdapter.new(user, project).fetch
    PlatformMaterialAdapter.new(user, project).fetch
    PlatformPaymentPointAdapter.new(user, project).fetch
    PlatformPaymentTermAdapter.new(user, project).fetch
    PlatformPaymentTypeAdapter.new(user, project).fetch
    PlatformPickupIntervalAdapter.new(user, project).fetch
    PlatformPriorityAdapter.new(user, project).fetch
    PlatformRouteTemplateAdapter.new(user, project).fetch
    PlatformServiceAdapter.new(user, project).fetch
    PlatformVatAdapter.new(user, project).fetch
    PlatformWeighingTypeAdapter.new(user, project).fetch
    PlatformZoneAdapter.new(user, project).fetch
  end
end
