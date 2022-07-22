class PlatformLocation < ApplicationRecord
  belongs_to :project
  belongs_to :platform_zone

  def full_address
    parts = [house_number, address_1, address_2, address_3, address_4, address_5, post_code]
  
    parts.reject!(&:blank?) 
  
    parts.join(", ")
  end  

  def as_platform_json
    { "Description": description,
      "UniqueReference": unqiue_reference,
      "Address": {
        "HouseNumber": house_number,
        "Address1": address_1,
        "Address2": address_2,
        "Address3": address_3,
        "Address4": address_4,
        "Address5": address_5,
        "Postcode": post_code,
        "ContactMethods": {
          "TelNo": tel_no
        }
      },
      "Geo": {
        "ZoneListItem": {
          "Guid": platform_zone.guid
        },
        "ParcelBoundaryListItem": nil,
        "Location": {
          "Lat": latitude.to_f,
          "Long": longitude.to_f
        },
        "Latitude": latitude.to_f,
        "Longitude": longitude.to_f
      } }.to_json
  end  
end
