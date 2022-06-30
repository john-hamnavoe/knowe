class PlatformLiftEvent < ApplicationRecord
  belongs_to :project
  belongs_to :platform_order_item, optional: true
  belongs_to :platform_vehicle, optional: true

  def as_platform_json
    chargable_weight = charge_weight.nil? ? net_weight : charge_weight

    site_order_item_guid = related_site_order_container_guid.nil? ? platform_order_item&.guid : related_site_order_container_guid

    lift_event = {
      "IsAutoGPSMatching": false,
      "IsAutoGPSMatchingResult": false,
      "IsBilled": false,
      "IsCollected": is_collected,
      "IsContaminated": false,
      "IsDriverGPSMatching": false,
      "IsDriverGPSMatchingResult": false,
      "IsDumped": true,
      "IsAdHoc": true,
      "IsCombinedLift": false,
      "IsGeoCompressed": false,
      "IsManual": false,
      "IsOnHold": false,
      "IsOverridden": false,
      "IsStopListed": false,
      "ChargeWeight": chargable_weight.to_f,
      "NetWeight": chargable_weight.to_f,
      "Weight": chargable_weight.to_f,
      "GPSMatchingSourceListItem": {
      },
      "ReasonLastChangeListItem": {
      },
      "ReasonLiftInformationListItem": {
      },
      "ReasonLiftProblemListItem": {
      },
      "ContainerTypeNewOfficeListItem": {
      },
      "MaterialTypeNewOfficeListItem": {
      },
      "UnitOfMeasurementListItem": {
      },
      "WeightChangeReasonListItem": {
      },
      "VehicleCode": vehicle_code,
      "InformationText": information_text,
      "LiftText": lift_text,
      "ProblemText": problem_text,
      "Tag": tag,
      "CollectionDate": collection_date,
      "CollectionTimeStamp": collection_time_stamp,
      "RelatedRouteGuid": related_route_guid,
      "RelatedRouteVisitGuid": related_route_visit_guid,
      "RelatedSiteOrderContainerGuid": site_order_item_guid,
      "IsDeleted": is_deleted,
      "GUID": guid
    }

    lift_event = if latitude&.nonzero? && longitude&.nonzero?
                   lift_event.merge({ "Location": { "Lat": latitude.to_f, "Long": longitude.to_f } })
                 else
                   lift_event.merge({ "Location": {} })
                 end

    lift_event = lift_event.merge({ "RelatedVehicleGuid": platform_vehicle&.guid }) if platform_vehicle.present?

    lift_event.to_json
  end
end
