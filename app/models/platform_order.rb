# frozen_string_literal: true

class PlatformOrder < ApplicationRecord
  belongs_to :project
  belongs_to :platform_customer_site, optional: true # need for nested attribute save
  belongs_to :platform_service
  belongs_to :platform_material
  belongs_to :platform_company_outlet
  belongs_to :platform_container_type, optional: true
  belongs_to :platform_service_agreement, optional: true
  belongs_to :platform_priority, optional: true

  has_many :platform_item_rentals, dependent: :destroy
  has_many :platform_route_assignments, dependent: :destroy
  has_many :platform_order_items, dependent: :destroy
  has_many :platform_lift_events, through: :platform_order_items
  has_many :platform_jobs, dependent: :restrict_with_error

  accepts_nested_attributes_for :platform_order_items

  def as_platform_json
    { "RelatedSiteGuid": platform_customer_site.guid,
      "RelatedServiceAgreementGuid": platform_service_agreement.guid,
      "ProcessFrom": process_from,
      "IsCustomerOwnedEquipment": is_customer_owned_equipment,
      "Notes": notes,
      "DriverNotes": driver_notes,
      "CompanyOutletListItem": {
        "Guid": platform_company_outlet.guid
      },
      "ServiceListItem": {
        "Guid": platform_service.guid
      },
      "MaterialListItem": {
        "Guid": platform_material.guid
      },
      "DefaultContainerTypeListItem": {
        "Guid": platform_container_type.guid
      },
      "AreaOfOriginListItem": {
      },
      "PriorityListItem": {
        "Guid": platform_priority.guid
      },
      "RelatedLocationDestinationGuid": platform_company_outlet.location_guid,
      "RelatedOrderCombinationGroupingGuid": nil, # cant post this need to create it in table
      "Containers": platform_containers_as_json,
      "ItemRentals": platform_rentals_as_json,
      "RouteAssignments": platform_route_assignments_as_json,
      "StandingJobs": [],
      "GUID": guid }.to_json
  end

  private

  def platform_route_assignments_as_json
    assignments = []

    platform_route_assignments.each do |assignment|
      platform_assignment = {
        "Guid": assignment.guid,
        "ActionListItem": {
          "Guid": assignment.platform_action.guid
        },
        "ContainerTypeListItem": {
          "Guid": assignment.platform_container_type.guid
        },
        "PickupIntervalListItem": {
          "Guid": assignment.platform_pickup_interval.guid
        },

        "DayOfOccurrenceInMonthListItem": {},
        "Position": assignment.position,
        "StartDate": assignment.start_date,
        "RequiresQuantity": false,
        "IsGpsAutoMatchingDisabled": false,

        "IsNoBinOnSiteExcluded": false,
        "IsDeleted": false,
        "Exclusions": []
      }

      platform_assignment = if assignment.platform_day_of_week.nil?
                              platform_assignment.merge({ "IsNoPlannedDate": true, "DayOfWeekListItem": {} })
                            else
                              platform_assignment.merge({ "IsNoPlannedDate": false, "DayOfWeekListItem": { "Guid": assignment.platform_day_of_week.guid } })
                            end

      platform_assignment = platform_assignment.merge({ "RelatedRouteTemplateGuid": assignment.platform_route_template.guid }) if assignment.platform_route_template.present?

      assignments << platform_assignment
    end

    assignments
  end

  def platform_rentals_as_json
    rentals = []

    platform_item_rentals.each do |rental|
      platform_rental = {
        "RelatedPriceGuid": rental.platform_price.guid,
        "ContainerTypeListItem": {
          "Guid": rental.platform_container_type.guid
        },
        "ActionListItem": {
          "Guid": rental.platform_action.guid
        },
        "StartDate": rental.start_date,
        "IsStartOnStartOfCycle": false,
        "IsEndOnEndOfCycle": true,
        "Quantity": rental.quantity,
        "IsArrears": rental.is_arrears,
        "RentalQuantityAttributeListItem": {},
        "IsBinOnSiteBasedOnQuantityNow": false,
        "IsDiscount": false,
        "DiscountReasonListItem": {},
        "Guid": rental.guid
      }

      rentals << platform_rental
    end
    rentals
  end

  def platform_containers_as_json
    containers = []

    platform_order_items.each do |order_item|
      containers << {
        "Guid": order_item.guid,
        "IsDeleted": order_item.is_deleted,
        "RelatedContainerGuid": order_item&.platform_container&.guid || order_item.related_container_guid,
        "ContainerTypeListItem": {
          "Guid": order_item.platform_container_type.guid
        },
        "ContainerStateListItem": {
          "Guid": order_item.platform_container_status.guid
        }
      }
    end
    containers
  end
end
