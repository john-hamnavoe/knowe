# frozen_string_literal: true

class ImportPlatformServiceAgreementsJob < ApplicationJob
  discard_on StandardError # discard if fails
  queue_as :default

  def perform(user, project, _outlet_guid)
    PlatformServiceAgreementAdapter.new(user, project).fetch(nil)
  end
end
