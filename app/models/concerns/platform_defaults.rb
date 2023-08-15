# frozen_string_literal: true

module PlatformDefaults
  extend ActiveSupport::Concern

  def create_default_platform_settings
    PlatformSetting.create(project: self, class_name: "PlatformAction", position: 10) unless PlatformSetting.where(class_name: "PlatformAction", project: self).exists?
    PlatformSetting.create(project: self, class_name: "PlatformBusinessType", position: 20) unless PlatformSetting.where(class_name: "PlatformBusinessType", project: self).exists?
    PlatformSetting.create(project: self, class_name: "PlatformContactType", position: 30) unless PlatformSetting.where(class_name: "PlatformContactType", project: self).exists?
    PlatformSetting.create(project: self, class_name: "PlatformContainerType", position: 40) unless PlatformSetting.where(class_name: "PlatformContainerType", project: self).exists?
    PlatformSetting.create(project: self, class_name: "PlatformContractStatus", position: 50) unless PlatformSetting.where(class_name: "PlatformContractStatus", project: self).exists?
    PlatformSetting.create(project: self, class_name: "PlatformCurrency", position: 60) unless PlatformSetting.where(class_name: "PlatformCurrency", project: self).exists?
    PlatformSetting.create(project: self, class_name: "PlatformCustomerCategory", position: 65) unless PlatformSetting.where(class_name: "PlatformCustomerCategory", project: self).exists?
    PlatformSetting.create(project: self, class_name: "PlatformCustomerSiteState", position: 70) unless PlatformSetting.where(class_name: "PlatformCustomerSiteState", project: self).exists?
    PlatformSetting.create(project: self, class_name: "PlatformCustomerState", position: 80) unless PlatformSetting.where(class_name: "PlatformCustomerState", project: self).exists?
    PlatformSetting.create(project: self, class_name: "PlatformCustomerTemplate", position: 90) unless PlatformSetting.where(class_name: "PlatformCustomerTemplate", project: self).exists?
    PlatformSetting.create(project: self, class_name: "PlatformCustomerType", position: 100) unless PlatformSetting.where(class_name: "PlatformCustomerType", project: self).exists?
    PlatformSetting.create(project: self, class_name: "PlatformDayOfWeek", position: 110) unless PlatformSetting.where(class_name: "PlatformDayOfWeek", project: self).exists?
    PlatformSetting.create(project: self, class_name: "PlatformDepartment", position: 120) unless PlatformSetting.where(class_name: "PlatformDepartment", project: self).exists?
    PlatformSetting.create(project: self, class_name: "PlatformDirectDebitRunConfiguration", position: 130) unless PlatformSetting.where(class_name: "PlatformDirectDebitRunConfiguration", project: self).exists?
    PlatformSetting.create(project: self, class_name: "PlatformDocumentDeliveryType", position: 140) unless PlatformSetting.where(class_name: "PlatformDocumentDeliveryType", project: self).exists?
    PlatformSetting.create(project: self, class_name: "PlatformExternalVehicle", position: 150) unless PlatformSetting.where(class_name: "PlatformExternalVehicle", project: self).exists?
    PlatformSetting.create(project: self, class_name: "PlatformInvoiceCycle", position: 160) unless PlatformSetting.where(class_name: "PlatformInvoiceCycle", project: self).exists?
    PlatformSetting.create(project: self, class_name: "PlatformInvoiceFrequency", position: 170) unless PlatformSetting.where(class_name: "PlatformInvoiceFrequency", project: self).exists?
    PlatformSetting.create(project: self, class_name: "PlatformMaterial", position: 180) unless PlatformSetting.where(class_name: "PlatformMaterial", project: self).exists?
    PlatformSetting.create(project: self, class_name: "PlatformPaymentPoint", position: 190) unless PlatformSetting.where(class_name: "PlatformPaymentPoint", project: self).exists?
    PlatformSetting.create(project: self, class_name: "PlatformPaymentTerm", position: 200) unless PlatformSetting.where(class_name: "PlatformPaymentTerm", project: self).exists?
    PlatformSetting.create(project: self, class_name: "PlatformPaymentType", position: 210) unless PlatformSetting.where(class_name: "PlatformPaymentType", project: self).exists?
    PlatformSetting.create(project: self, class_name: "PlatformPickupInterval", position: 220) unless PlatformSetting.where(class_name: "PlatformPickupInterval", project: self).exists?
    PlatformSetting.create(project: self, class_name: "PlatformPriority", position: 230) unless PlatformSetting.where(class_name: "PlatformPriority", project: self).exists?
    PlatformSetting.create(project: self, class_name: "PlatformService", position: 240) unless PlatformSetting.where(class_name: "PlatformService", project: self).exists?
    PlatformSetting.create(project: self, class_name: "PlatformVat", position: 250) unless PlatformSetting.where(class_name: "PlatformVat", project: self).exists?
    PlatformSetting.create(project: self, class_name: "PlatformWeighingType", position: 260) unless PlatformSetting.where(class_name: "PlatformWeighingType", project: self).exists?
    PlatformSetting.create(project: self, class_name: "PlatformZone", position: 270) unless PlatformSetting.where(class_name: "PlatformZone", project: self).exists?
    PlatformSetting.create(project: self, class_name: "PlatformCompanyOutlet", position: 280) unless PlatformSetting.where(class_name: "PlatformCompanyOutlet", project: self).exists?
    PlatformSetting.create(project: self, class_name: "PlatformRouteTemplate", position: 290) unless PlatformSetting.where(class_name: "PlatformRouteTemplate", project: self).exists?
    PlatformSetting.create(project: self, class_name: "PlatformDefaultAction", position: 300) unless PlatformSetting.where(class_name: "PlatformDefaultAction", project: self).exists?
    PlatformSetting.create(project: self, class_name: "PlatformSicCode", position: 310) unless PlatformSetting.where(class_name: "PlatformSicCode", project: self).exists?
    PlatformSetting.create(project: self, class_name: "PlatformVehicleType", position: 320) unless PlatformSetting.where(class_name: "PlatformVehicleType", project: self).exists?
    PlatformSetting.create(project: self, class_name: "PlatformVehicle", position: 330) unless PlatformSetting.where(class_name: "PlatformVehicle", project: self).exists?
    PlatformSetting.create(project: self, class_name: "PlatformAccountingPeriod", position: 340) unless PlatformSetting.where(class_name: "PlatformAccountingPeriod", project: self).exists?     
    PlatformSetting.create(project: self, class_name: "PlatformSchedule", position: 350) unless PlatformSetting.where(class_name: "PlatformSchedule", project: self).exists?     
  end

  def create_default_platform_posts
    PlatformPost.create(project: self, class_name: "PlatformLiftEvent", position: 10) unless PlatformPost.where(class_name: "PlatformLiftEvent", project: self).exists? 
  end 
end

