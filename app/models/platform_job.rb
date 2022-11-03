class PlatformJob < ApplicationRecord
  belongs_to :platform_action
  belongs_to :platform_company_outlet
  belongs_to :project
  belongs_to :platform_order, optional: true
  belongs_to :platform_container_type, optional: true
  belongs_to :platform_material, optional: true
  belongs_to :platform_vat, optional: true
  belongs_to :platform_order_item, optional: true
  belongs_to :platform_schedule, optional: true

  def as_platform_json
    job = { "DeleteRouteAssignmentsOnCompletion": delete_route_assignments_on_completion,
            "InProgress": in_progress,
            "IsAdhoc": is_adhoc,
            "IsCompleted": is_completed,
            "IsConfirmed": is_confirmed,
            "IsExternalTransport": is_external_transport,
            "IsFinanciallyConfirmed": is_financially_confirmed,
            "IsHazardousPaperworkComplete": is_hazardous_paperwork_complete,
            "IsScheduledTransfer": is_scheduled_transfer,
            "IsWarranty": is_warranty,
            "RelatedSiteOrderGuid": related_site_order_guid || platform_order&.guid,
            "ActionListItem": {
              "Guid": platform_action.guid
            },
            "CompanyOutletListItem": {
              "Guid": platform_company_outlet.guid
            },
            "ContainerTypeListItem": {
              "Guid": platform_container_type&.guid
            },
            "MaterialListItem": {
              "Guid": platform_material&.guid
            },
            "VisitDetails": {
              "DriverNotes": notes,
            },
            "CustomerOrderNo": customer_order_no,
            "DateRequired": date_required,
            "TicketNo": ticket_no,
            "HazardousLoadReference": hazardous_load_reference,
            "ManualTicketNo": manual_ticket_no,
            "Notes": notes,
            "PONumber": po_number,
            "Quantity": quantity,
            "RelatedLocationDestinationGuid": related_location_destination_guid || platform_company_outlet&.location_guid,
            "PriceOverrides": [],
            "ContainerDetails": {},
            "RejectedReasonListItem": {},
            "Access": [],
            "VATIntendedListItem": {
              "Guid": platform_vat&.guid
            },
            "RelatedBlobJobDocketPdfHashes": [] }

    job = job.merge({ "RelatedSiteOrderItemGuid": platform_order_item.guid }) if platform_order_item.present?
    job = job.merge({ "PriceOverrides": [
      {
        "RelatedPriceGuid": related_price_guid,
        "Guid": price_override_guid,
        "OverrideRate": override_rate.to_f,
        "IsSelected": true
      }
    ]}) if price_override_guid.present? && override_rate.present?

    job.to_json
  end
end


# "resource": {
#   "DeleteRouteAssignmentsOnCompletion": false,
#   "InProgress": false,
#   "IsAdhoc": false,
#   "IsCompleted": true,
#   "CompletedDate": "2022-09-06",
#   "IsConfirmed": true,
#   "IsExternalTransport": false,
#   "IsFinanciallyConfirmed": true,
#   "IsHazardousPaperworkComplete": false,
#   "IsScheduledTransfer": false,
#   "IsWarranty": false,
#   "RelatedExternalVehicleGuid": null,
#   "RelatedPONumberGuid": null,
#   "RelatedRouteVisitGuid": null,
#   "RelatedScheduleGuid": null,
#   "RelatedSiteOrderGuid": "3ded44ec-483c-4470-8e46-aec200dcca5f",
#   "RelatedSiteOrderItemGuid": null,
#   "RelatedSupplierSiteTransportGuid": "dd3e69eb-fefc-4e27-a379-74167b75e4ea",
#   "ActionListItem": {
#     "Description": "Fuel Charge Test",
#     "Guid": "899b803d-3b75-4847-8fb9-af08010ce094"
#   },
#   "CancelledReasonListItem": null,
#   "CompanyOutletListItem": {
#     "Description": "Galway Office",
#     "Guid": "1a7cce04-df39-e911-85b3-00155d675d9a"
#   },
#   "ContainerTypeListItem": {
#     "Description": "240 Litre Bin",
#     "Guid": "f47bce04-df39-e911-85b3-00155d675d9a"
#   },
#   "DepartmentListItem": {
#     "Description": "Household",
#     "Guid": "e5400280-ee93-420a-b200-4e7b9b3aae50"
#   },
#   "MaterialListItem": {
#     "Description": "General Waste",
#     "Guid": "0acd040a-b1d7-466d-88cd-488b13016120"
#   },
#   "PaymentTypeListItem": null,
#   "RepairReasonListItem": null,
#   "Access": [],
#   "ContainerDetails": null,
#   "VisitDetails": {
#     "DriverNotes": null,
#     "TimeInCustomerSite": null,
#     "TimeOutCustomerSite": null,
#     "HoursChargeable": 0,
#     "HoursNotChargeable": null
#   },
#   "CustomerOrderNo": null,
#   "DateRequired": "2022-09-06",
#   "HazardousLoadReference": null,
#   "ManualTicketNo": null,
#   "Notes": "",
#   "PONumber": null,
#   "Quantity": null,
#   "ReleaseNumber": null,
#   "TicketNo": "JTG10737",
#   "RejectedReasonListItem": null,
#   "RelatedLocationDestinationGuid": "197cce04-df39-e911-85b3-00155d675d9a",
#   "RelatedPictureBlobHashes": [],
#   "RelatedBlobJobDocketPdfHashes": [],
#   "PriceOverrides": [
#     {
#       "RelatedPriceGuid": "7590bc55-1faa-45ad-abad-af08010d427e",
#       "Guid": "4a4a09d7-e195-44e7-bbe9-af080118ef46",
#       "OverrideRate": 4,
#       "IsSelected": true
#     }
#   ],
#   "RelatedPriceGuidFilter": null,
#   "RequiredStartTime": null,
#   "RequiredEndTime": null,
#   "VATIntendedListItem": {
#     "Description": "S (13.5%)",
#     "Guid": "cab365fb-df39-e911-85b3-00155d675d9a"
#   },
#   "ServiceListItem": {
#     "Description": "Household Service",
#     "Guid": "a9008b83-df39-e911-85b3-00155d675d9a"
#   },
#   "GUID": "f9d29d1c-8b1c-4102-b10d-af080118ee7d"
# }
