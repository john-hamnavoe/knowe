# frozen_string_literal: true

class PlatformDirectDebitRunConfigurationRepository < ApplicationRepository
  def all(args = {}, order_by = "description", direction = "asc")
    query = PlatformDirectDebitRunConfiguration.where( project: project).where(args)
    

    query.order(order_by => direction)
  end

  def load_by_guid(guid)
    PlatformDirectDebitRunConfiguration.find_by(guid: guid,  project: project)
  end

  def import(records)
    PlatformDirectDebitRunConfiguration.import records, on_duplicate_key_update: { conflict_target: [:guid, :project_id], columns: [:description, :is_deleted] }, returning: :guid
  end
end
