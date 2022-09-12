class AddRelatedCustomerGuidToPlatformServiceAgreement < ActiveRecord::Migration[7.0]
  def change
    add_column :platform_service_agreements, :related_customer_guid, :uuid
  end
end
