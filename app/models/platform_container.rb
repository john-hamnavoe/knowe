class PlatformContainer < ApplicationRecord
  belongs_to :project
  belongs_to :platform_container_status, optional: true
  belongs_to :platform_container_type
  belongs_to :platform_company_outlet, optional: true

  def as_platform_json
    { "IsCommercial": is_commercial,
      "IsStoplisted": is_stoplisted,
      "ContainerStatusListItem": nil,
      "ContainerTypeListItem": {
        "Guid": platform_container_type&.guid
      },
      "CompanyOutletListItem": {
        "Guid": platform_company_outlet&.guid
      },        
      "Manufacture": {},
      "Geo": {
        "Latitude": latitude.to_f,
        "Longitude": longitude.to_f
      },
      "Note": note,
      "SerialNo": serial_no,
      "Tag": tag,      
      "GUID": guid }.to_json
  end  
end

