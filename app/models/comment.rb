class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :notes

  validates :body, presence: true
end
