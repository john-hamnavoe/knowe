class PlatformSetting < ApplicationRecord
  belongs_to :project

  broadcasts_to ->(platform_setting) { :platform_settings }
end
