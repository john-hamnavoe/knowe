class AddRelatedServiceAgreementGuidToPlatformOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :platform_orders, :related_service_agreement_guid, :uuid
  end
end
