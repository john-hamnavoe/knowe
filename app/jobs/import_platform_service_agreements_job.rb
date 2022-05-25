# frozen_string_literal: true

class ImportPlatformServiceAgreementsJob < ApplicationJob
  discard_on StandardError # second catch other exceptions
  queue_as :default

  def perform(user, project, outlet_guid)
    PlatformServiceAgreementAdapter.new(user, project).fetch(outlet_guid)
  end
end
