class Tag < ApplicationRecord
  has_many :tag_maps, dependent: :destroy
  has_many :notes, through: :tag_maps

  validates :name, presence: true
end
