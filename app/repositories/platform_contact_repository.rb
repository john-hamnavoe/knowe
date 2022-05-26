# frozen_string_literal: true

class PlatformContactRepository < ApplicationRepository
  def all(args={}, order_by="surname", direction="asc")
    query = PlatformContact.where(project: project).where(args)

    query.order(order_by => direction)
  end

  def load(id)
    PlatformContact.find_by(id: id, project: project)
  end

  def load_by_guid(guid)
    PlatformContact.find_by(guid: guid, project: project)
  end

  def import(records)
    PlatformContact.import records, on_duplicate_key_update: { conflict_target: [:guid, :project_id], columns: [:forename, :surname, :tel_no, :platform_customer_id, :platform_contact_type_id, :email] }, returning: :guid
  end
end
