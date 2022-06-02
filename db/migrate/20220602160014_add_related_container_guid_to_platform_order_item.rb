class AddRelatedContainerGuidToPlatformOrderItem < ActiveRecord::Migration[7.0]
  def change
    add_column :platform_order_items, :related_container_guid, :uuid
    add_reference :platform_order_items, :platform_container, optional: true
  end
end
