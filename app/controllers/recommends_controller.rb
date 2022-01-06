class RecommendsController < ApplicationController
  def index
    # ユーザーがノートを作成していない場合、ユーザーはエンティティを持たないので
    # 全ノートからランダムで表示する
    entities = User.entities_of(current_user)

    rand = Rails.env.production? ? "RAND()" : "RANDOM()"
    if entities.present?
      # 対象エンティティをもつノートを取得し、ランダムに10件抽出する
      sql = 'entities.name LIKE? or entities.name LIKE? or entities.name LIKE?'
      @notes = Note
        .eager_load(:entities)
        .where(sql, "%#{entities[0]['name']}%", "%#{entities[1]['name']}%", "%#{entities[2]['name']}%")
        .order(rand)
        .limit(10)
        .includes([:user])
    else
      @notes = Note.order(rand).limit(10).includes([:user])
    end
  end
end
