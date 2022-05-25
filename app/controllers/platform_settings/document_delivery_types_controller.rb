# frozen_string_literal: true

class PlatformSettings::DocumentDeliveryTypesController < ApplicationController
  layout "application_settings"
  before_action :authenticate_user!
  before_action :set_title

  before_action :reload_document_delivery_types_from_platform

  def index
    @query, page = ransack_query(PlatformDocumentDeliveryType, "description asc")

    @pagy, @platform_document_delivery_types = pagy(@query.result(distinct: true), page: page)
  end

  private

  def reload_document_delivery_types_from_platform
    return if repo.all().count.positive?

    flash[:notice] = "DocumentDeliveryTypes are being fetched!"
    ImportPlatformSettingsJob.perform_later(current_user, current_user.current_project)
  end

  def repo
    @repo ||= PlatformDocumentDeliveryTypeRepository.new(current_user)
  end

  def set_title
    @title = "Platform Document Delivery Types"
  end
end
