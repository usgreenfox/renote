class Remind < ApplicationRecord
  belongs_to :user
  belongs_to :note

  validates :first_notice, presence: true
  validates :second_notice, presence: true
  validates :third_notice, presence: true
end
