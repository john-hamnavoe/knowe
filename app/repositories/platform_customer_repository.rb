# frozen_string_literal: true

class PlatformCustomerRepository < ApplicationRepository
  def all(args={})
    PlatformCustomer.where(project: project).where(args)
  end

  def load(id)
    PlatformCustomer.find_by(id: id,  project: project)
  end

  def load_by_guid(guid)
    PlatformCustomer.find_by(guid: guid,  project: project)
  end
end
