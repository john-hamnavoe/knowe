class AddThirdPartyKeysToProject < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :sms_third_party_key, :uuid
    add_column :projects, :email_third_party_key, :uuid
  end
end
