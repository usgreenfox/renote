class Note < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :reminds, dependent: :destroy
  has_many :tag_maps, dependent: :destroy
  has_many :tags, through: :tag_maps
  has_many :entities, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true
  validates :user_id, presence: true

  def bookmarked_by?(user)
    self.bookmarks.where(user_id: user.id).exists?
  end

  def remind_to?(user)
    self.reminds.where(user_id: user.id).exists?
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

  # develop => SQLite, production => MySQLのため
  RANDOM_SORT = Rails.env.production? ? "RAND()" : "RANDOM()"
  def self.random_search(entities)
    return includes(:user).order(RANDOM_SORT).limit(5) unless entities

    column = 'entities.name LIKE?'
    columns, keywords, notes = [], [], []
    entities[0..49].each do |entity|
      # 検索ワードにエンティティを追加していく
      keywords << "%#{entity}%"
      # 検索ワードと'xxx LIKE?'の数を合わせる
      columns << column
      # 'xxx LIKE?'を'or'で繋ぐ
      sql = columns.join(' or ')

      notes = eager_load(:user, :entities).where(sql, *keywords).order(Arel.sql(RANDOM_SORT))

      # ノートが5個以上取得できた時点で終了
      break if notes.count > 5
    end
    notes
  end

  def registration_entities
    # 変種前のエンティティを削除
    entities.destroy_all if entities.present?
    # Natural Language APIよりエンティティを取得
    get_entities = Language.get_data(body)

    # slienceの高い10個をDBに登録
    get_entities[0..9].each do |entity|
      entities.new(
        name: entity['name'],
        salience: entity['salience'],
        category: entity['type'],
        user_id: user_id
        )
    end
  end

end