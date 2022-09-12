# frozen_string_literal: true

class PlatformServiceAgreementRepository < ApplicationRepository
  def all(args = {}, order_by = "description", direction = "asc")
    query = PlatformServiceAgreement.eager_load(:platform_company_outlet, :platform_prices).where( project: project).where(args)

    query.order(order_by => direction)
  end

  def load(id)
    PlatformServiceAgreement.eager_load(:platform_company_outlet, :platform_prices).find_by(id: id,  project: project)
  end

  def load_by_guid(guid)
    PlatformServiceAgreement.eager_load(:platform_company_outlet, :platform_prices).find_by(guid: guid,  project: project)
  end

  def import(records)
    PlatformServiceAgreement.import records, on_duplicate_key_update: { conflict_target: [:guid, :project_id], columns: [:platform_company_outlet_id, :description, :related_customer_guid] }, returning: :guid
  end
end
