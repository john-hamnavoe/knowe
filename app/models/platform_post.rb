class PlatformPost < ApplicationRecord
  belongs_to :project

  broadcasts_to ->(platform_post) { :platform_posts }
end
