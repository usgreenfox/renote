class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :note

  validates :body, presence: true
end
