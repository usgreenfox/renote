class Note < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :reminds, dependent: :destroy
  has_many :tag_maps, dependent: :destroy
  has_many :tags, through: :tag_maps

  validates :title, presence: true
  validates :body, presence: true

  def bookmarked_by?(user)
    bookmarks.find_by(user_id: user.id).exists?
  end

  def remind_to?(user)
    reminds.find_by(user_id: user.id).exists?
  end
  
  def save_tag(sent_tags)
    # 現在登録されているタグを配列で取得
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    
    # 現在登録するタグと今回登録するタグとの差分を削除
    old_tags = current_tags - sent_tags
    old_tags.each do |old_tag|
      self.tags.delete Tag.find_by(name: old_tag)
    end
    
    # 今回新規で登録するタグを作成
    new_tags = sent_tags - current_tags
    new_tags.each do |new_tag|
      new_post_tag = Tag.find_or_create_by(name: new_tag)
      self.tags << new_post_tag
    end
  end

end
