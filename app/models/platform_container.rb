class PlatformContainer < ApplicationRecord
  belongs_to :project
  belongs_to :platform_container_status, optional: true
  belongs_to :platform_container_type
  belongs_to :platform_company_outlet, optional: true

  def as_platform_json
    { "IsStoplisted": is_stoplisted,
      "GUID": guid }.to_json
  end  
end
