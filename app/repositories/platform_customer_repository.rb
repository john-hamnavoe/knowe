# frozen_string_literal: true

class PlatformCustomerRepository < ApplicationRepository
  def load(id)
    PlatformCustomer.find_by(id: id,  project: project)
  end

  def load_by_guid(guid)
    PlatformCustomer.find_by(guid: guid,  project: project)
  end
end
