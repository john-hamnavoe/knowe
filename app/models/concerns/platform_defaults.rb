# frozen_string_literal: true

module PlatformDefaults
  extend ActiveSupport::Concern

  def create_default_platform_settings(project)
    PlatformSetting.create(project: project, class_name: "PlatformAction", position: 1) unless PlatformSetting.where(class_name: "PlatformAction", project: project).exists?
    PlatformSetting.create(project: project, class_name: "PlatformBusinessType", position: 2) unless PlatformSetting.where(class_name: "PlatformBusinessType", project: project).exists?
    PlatformSetting.create(project: project, class_name: "PlatformContactType", position: 3) unless PlatformSetting.where(class_name: "PlatformContactType", project: project).exists?
    PlatformSetting.create(project: project, class_name: "PlatformContainerType", position: 4) unless PlatformSetting.where(class_name: "PlatformContainerType", project: project).exists?
    PlatformSetting.create(project: project, class_name: "PlatformContractStatus", position: 5) unless PlatformSetting.where(class_name: "PlatformContractStatus", project: project).exists?
    PlatformSetting.create(project: project, class_name: "PlatformCurrency", position: 6) unless PlatformSetting.where(class_name: "PlatformCurrency", project: project).exists?
    PlatformSetting.create(project: project, class_name: "PlatformCustomerSiteState", position: 7) unless PlatformSetting.where(class_name: "PlatformCustomerSiteState", project: project).exists?
    PlatformSetting.create(project: project, class_name: "PlatformCustomerState", position: 8) unless PlatformSetting.where(class_name: "PlatformCustomerState", project: project).exists?
    PlatformSetting.create(project: project, class_name: "PlatformCustomerTemplate", position: 9) unless PlatformSetting.where(class_name: "PlatformCustomerTemplate", project: project).exists?
    PlatformSetting.create(project: project, class_name: "PlatformCustomerType", position: 10) unless PlatformSetting.where(class_name: "PlatformCustomerType", project: project).exists?
    PlatformSetting.create(project: project, class_name: "PlatformDayOfWeek", position: 11) unless PlatformSetting.where(class_name: "PlatformDayOfWeek", project: project).exists?
    PlatformSetting.create(project: project, class_name: "PlatformDepartment", position: 12) unless PlatformSetting.where(class_name: "PlatformDepartment", project: project).exists?
    PlatformSetting.create(project: project, class_name: "PlatformDirectDebitRunConfiguration", position: 13) unless PlatformSetting.where(class_name: "PlatformDirectDebitRunConfiguration", project: project).exists?
    PlatformSetting.create(project: project, class_name: "PlatformDocumentDeliveryType", position: 14) unless PlatformSetting.where(class_name: "PlatformDocumentDeliveryType", project: project).exists?
    PlatformSetting.create(project: project, class_name: "PlatformExternalVehicle", position: 15) unless PlatformSetting.where(class_name: "PlatformExternalVehicle", project: project).exists?
    PlatformSetting.create(project: project, class_name: "PlatformInvoiceCycle", position: 16) unless PlatformSetting.where(class_name: "PlatformInvoiceCycle", project: project).exists?
    PlatformSetting.create(project: project, class_name: "PlatformInvoiceFrequency", position: 17) unless PlatformSetting.where(class_name: "PlatformInvoiceFrequency", project: project).exists?
    PlatformSetting.create(project: project, class_name: "PlatformMaterial", position: 18) unless PlatformSetting.where(class_name: "PlatformMaterial", project: project).exists?
    PlatformSetting.create(project: project, class_name: "PlatformPaymentPoint", position: 19) unless PlatformSetting.where(class_name: "PlatformPaymentPoint", project: project).exists?
    PlatformSetting.create(project: project, class_name: "PlatformPaymentTerm", position: 20) unless PlatformSetting.where(class_name: "PlatformPaymentTerm", project: project).exists?
    PlatformSetting.create(project: project, class_name: "PlatformPaymentType", position: 21) unless PlatformSetting.where(class_name: "PlatformPaymentType", project: project).exists?
    PlatformSetting.create(project: project, class_name: "PlatformPickupInterval", position: 22) unless PlatformSetting.where(class_name: "PlatformPickupInterval", project: project).exists?
    PlatformSetting.create(project: project, class_name: "PlatformPriority", position: 23) unless PlatformSetting.where(class_name: "PlatformPriority", project: project).exists?
    PlatformSetting.create(project: project, class_name: "PlatformService", position: 24) unless PlatformSetting.where(class_name: "PlatformService", project: project).exists?
    PlatformSetting.create(project: project, class_name: "PlatformVat", position: 25) unless PlatformSetting.where(class_name: "PlatformVat", project: project).exists?
    PlatformSetting.create(project: project, class_name: "PlatformWeighingType", position: 26) unless PlatformSetting.where(class_name: "PlatformWeighingType", project: project).exists?
    PlatformSetting.create(project: project, class_name: "PlatformZone", position: 27) unless PlatformSetting.where(class_name: "PlatformZone", project: project).exists?
    PlatformSetting.create(project: project, class_name: "PlatformCompanyOutlet", position: 28) unless PlatformSetting.where(class_name: "PlatformCompanyOutlet", project: project).exists?
    PlatformSetting.create(project: project, class_name: "PlatformRouteTemplate", position: 29) unless PlatformSetting.where(class_name: "PlatformRouteTemplate", project: project).exists?
    PlatformSetting.create(project: project, class_name: "PlatformDefaultAction", position: 30) unless PlatformSetting.where(class_name: "PlatformDefaultAction", project: project).exists?
    PlatformSetting.create(project: project, class_name: "PlatformSicCode", position: 31) unless PlatformSetting.where(class_name: "PlatformSicCode", project: project).exists?
    PlatformSetting.create(project: project, class_name: "PlatformVehicleType", position: 32) unless PlatformSetting.where(class_name: "PlatformVehicleType", project: project).exists?
    PlatformSetting.create(project: project, class_name: "PlatformVehicle", position: 33) unless PlatformSetting.where(class_name: "PlatformVehicle", project: project).exists?
    PlatformSetting.create(project: project, class_name: "PlatformAccountingPeriod", position: 34) unless PlatformSetting.where(class_name: "PlatformAccountingPeriod", project: project).exists?     
    PlatformSetting.create(project: project, class_name: "PlatformSchedule", position: 35) unless PlatformSetting.where(class_name: "PlatformSchedule", project: project).exists?     
  end

  def create_default_platform_posts(project)
    PlatformPost.create(project: project, class_name: "PlatformLiftEvent", position: 1) unless PlatformPost.where(class_name: "PlatformLiftEvent", project: project).exists? 
  end 
end

