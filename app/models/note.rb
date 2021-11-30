class Note < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :reminds, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true

  def bookmarked_by?(user)
    bookmarks.find_by(user_id: user.id).exists?
  end

  def remind_to?(user)
    reminds.find_by(user_id: user.id).exists?
  end

end
