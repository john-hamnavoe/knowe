class Project < ApplicationRecord
  include PlatformDefaults

  broadcasts_to ->(project) { :projects }
  belongs_to :user
  
  validates :name, presence: true, length: { maximum: 50 }
  scope :active, -> { where(is_active: true).order(:name) }

  has_many :platform_settings, dependent: :destroy
  has_many :platform_actions, dependent: :destroy
  has_many :platform_business_types, dependent: :destroy

  after_commit :defaults_configure

  private

  def defaults_configure
    create_default_platform_settings(self)
    create_default_platform_posts(self)
  end
end
