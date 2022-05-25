class Project < ApplicationRecord
  broadcasts_to ->(project) { :projects }
  belongs_to :user
  
  validates :name, presence: true, length: { maximum: 50 }
  scope :active, -> { where(is_active: true).order(:name) }

  has_many :platform_actions, dependent: :destroy
  has_many :platform_business_types, dependent: :destroy
end
