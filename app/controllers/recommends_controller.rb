class RecommendsController < ApplicationController
  def index
    # develop => SQLite, production => MySQLのため
    rand = Rails.env.production? ? "RAND()" : "RANDOM()"

    entities = current_user.build_entities
    if entities.present?
      # 対象エンティティをもつノートを取得し、ランダムに10件抽出する

      column = 'entities.name LIKE?'
      columns = []
      keywords = []

      entities[0..49].each do |entity|
        # 検索ワードにエンティティを追加していく
        keywords << "%#{entity}%"
        # 検索ワードと'xxx LIKE?'の数を合わせる
        columns << column

        # 'xxx LIKE?'を'or'で繋ぐ
        sql = columns.join(' or ')

        @notes = Note
          .eager_load(:entities)
          .where(sql, *keywords)
          .order(Arel.sql(rand))
          .includes([:user])

        # ノートが5個以上取得できた時点で終了
        if @notes.count > 5
          break
        end
      end
    else
      # ユーザーがノートを作成していない場合、ユーザーはエンティティを持たないので
      # 全ノートからランダムで表示する
      @notes = Note.order(rand).limit(5).includes([:user])
    end
  end
end
