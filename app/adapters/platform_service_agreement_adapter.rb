# frozen_string_literal: true

class PlatformServiceAgreementAdapter < ApplicationAdapter
  def fetch(_outlet_guid)
    load_standing_data
    import_all_service_agreements(bookmark_repo.find(PlatformBookmark::SERVICE_AGREEMENT))
  end

  private

  def load_standing_data
    @company_outlets = PlatformCompanyOutletRepository.new(user, project).all
    @services = PlatformServiceRepository.new(user, project).all
    @actions = PlatformActionRepository.new(user, project).all
    @container_types = PlatformContainerTypeRepository.new(user, project).all
    @materials = PlatformMaterialRepository.new(user, project).all
  end

  # don't believe the outlet filter works
  def import_service_agreements(outlet_guid)
    response = query_with_filter("integrator/erp/productCatalogue/serviceAgreements", "filter=CompanyOutletListItemGuidFilter eq '#{outlet_guid}'")
    return unless response.success?

    agreements, prices = service_agreements_from_response(response.data)
    service_agreement_repo.import(agreements)

    # after agreements saved set the platform_service_agreement_id to be new ID
    saved_agreements = service_agreement_repo.all
    prices.each do |price|
      service_agreement_id = saved_agreements.find { |c| c.guid == price[:platform_service_agreement_id] }&.id
      price[:platform_service_agreement_id] = service_agreement_id
    end

    price_repo.import(prices)
  end

  def import_all_service_agreements(bookmark)
    agreements = []
    prices = []

    response = query_changes("integrator/erp/productCatalogue/serviceAgreements/changes", bookmark&.until_bookmark, bookmark&.cursor_bookmark)
    next_agreements, next_prices = service_agreements_from_response(response.data) if response.success?
    agreements += next_agreements
    prices += next_prices

    until response.cursor.nil?
      response = query_changes("integrator/erp/productCatalogue/serviceAgreements/changes", nil, response.cursor)
      next_agreements, next_prices = service_agreements_from_response(response.data) if response.success?
      agreements += next_agreements
      prices += next_prices
    end
    bookmark_repo.create_or_update(PlatformBookmark::SERVICE_AGREEMENT, response.until, response.cursor)

    service_agreement_repo.import(agreements)

    PlatformSettingRepository.new(nil, project).update_last_response("PlatformServiceAgreement", response.code)
    # after agreements saved set the platform_service_agreement_id to be new ID
    saved_agreements = service_agreement_repo.all
    prices.each do |price|
      service_agreement_id = saved_agreements.find { |c| c.guid == price[:platform_service_agreement_id] }&.id
      price[:platform_service_agreement_id] = service_agreement_id
    end

    price_repo.import(prices)
  end

  def service_agreements_from_response(response_data)
    agreements = []
    prices = []
    response_data[:resource].each do |service_agreement|
      company_outlet_id = @company_outlets.find { |c| c.guid == service_agreement[:resource][:OutletListItem][:Guid] }&.id
      agreements << { project_id: project.id,
                      guid: service_agreement[:resource][:GUID],
                      description: service_agreement[:resource][:Description],
                      related_customer_guid: service_agreement[:resource][:RelatedCustomerGuid],
                      platform_company_outlet_id: company_outlet_id }
      service_agreement[:resource][:Prices].each do |price|
        action_id = @actions.find { |c| c.guid == price[:ActionListItem][:Guid] }&.id
        service_id = @services.find { |c| c.guid == price[:ServiceListItem][:Guid] }&.id
        material_id = price[:MaterialListItem].present? ? @materials.find { |c| c.guid == price[:MaterialListItem][:Guid] }&.id : nil
        container_type_id = price[:ContainerTypeListItem].present? ? @container_types.find { |c| c.guid == price[:ContainerTypeListItem][:Guid] }&.id : nil
        prices << { project_id: project.id,
                    guid: price[:Guid],
                    description: price[:DefaultActionExternalDescription],
                    platform_action_id: action_id,
                    platform_material_id: material_id,
                    platform_container_type_id: container_type_id,
                    platform_service_id: service_id,
                    amount: price[:Amount][:Price],
                    effective_from: price[:EffectiveFrom]&.to_date,
                    effective_to: price[:EffectiveTo]&.to_date,
                    platform_service_agreement_id: service_agreement[:resource][:GUID] }
      end
    end
    return agreements, prices
  end

  def service_agreement_repo
    @service_agreement_repo ||= PlatformServiceAgreementRepository.new(user, project)
  end

  def price_repo
    @price_repo ||= PlatformPriceRepository.new(user, project)
  end

  def bookmark_repo
    @bookmark_repo ||= PlatformBookmarkRepository.new(user, project)
  end
end
