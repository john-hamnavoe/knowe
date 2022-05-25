# frozen_string_literal: true

class PlatformJobAdapter < ApplicationAdapter
  def create(platform_job)
    return unless platform_job.guid.nil?

    response = post("integrator/erp/transport/jobs", platform_job.as_platform_json)
    if response.success?
      platform_job.update(guid: response.data[:resource], last_response_body: response.body, last_response_code: response.code)
    else
      platform_job.update(last_response_body: response.body, last_response_code: response.code)
    end
    response
  end

  def update
    body = {
      "IsCompleted": true,
      "CompletedDate": "2021-12-10",
      "GUID": "38cbc8fa-beb3-40d2-a8f9-adfa010271d1"
    }.to_json
    response = put("integrator/erp/transport/jobs", "38cbc8fa-beb3-40d2-a8f9-adfa010271d1", body)
    response
  end

  def update_location
    body = {
      "Description": "Maple Leaf - Madison - Ivy St",
      "Address": {
        "HouseNumber": "3398",
        "Address1": "Ivy Street",
        "Address2": "Madison",
        "Address3": "Dane County",
        "Address4": "Wisconsin",
        "Address5": "United States of America",
        "Postcode": "53714",
        "ContactMethods": {
          "TelNo": "07866383201",
          "FaxNo": nil
        },
        "PostTownListItem": nil,
        "RegionCodeListItem": nil
      },
      "TimeZone": nil,
      "LegalName": nil,
      "Directions": nil,
      "Geo": {
        "ZoneListItem": {
          "Description": "Kirkwall Zone",
          "Guid": "367139cc-beb3-4474-a419-adc500ed59a6"
        },
        "ParcelBoundaryListItem": nil,
        "Location": {
          "Lat": 55.85050,
          "Long": -4.44445
        },
        "Latitude": 55.85050,
        "Longitude": -4.44445
      },
      "UniqueReference": nil,
      "Acreage": nil,
      "GUID": "f7a376d2-c130-ec11-ae72-a085fcbc6ce0"
    }.to_json
    response = put("integrator/erp/directory/locations", "f7a376d2-c130-ec11-ae72-a085fcbc6ce0", body)
    response
  end
end
