class PlatformServiceAgreement < ApplicationRecord
  belongs_to :project
  belongs_to :platform_company_outlet

  has_many :platform_prices, dependent: :destroy
end
