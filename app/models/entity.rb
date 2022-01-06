class Entity < ApplicationRecord
  belongs_to :user
  belongs_to :note

  def self.registration_entities(note)
    # 変種前のエンティティを削除
    if note.entities.present?
      note.entities.destroy_all
    end

    # Natural Language APIよりエンティティを取得
    entities = Language::get_data(note.body)

    # slienceの高い3つをDBに登録
    entities[0..9].each do |entity|
      note.entities.new(
        name: entity['name'],
        salience: entity['salience'],
        category: entity['type'],
        user_id: note.user_id
        )
    end
  end
end
