class RecommendsController < ApplicationController
  def index
    # 文字数の少なすぎるノートは、エンティティが高くなる傾向のため除外
    # Trixによりdivタグが発生するため除外(他のHTMLタグについては)
    query = Entity.eager_load(:note).where('length(notes.body) >= 100').where.not(name: 'div')

    # ユーザーがノートを作成していない場合、ユーザーはエンティティを持たないので
    # 全エンティティで検索する
    entities = query.where(user_id: current_user.id).order(salience: :DESC).limit(3)
    if !entities.present?
      entities = query.order(salience: :DESC).limit(3)
    end

    # 対象エンティティをもつノートを取得し、ランダムに10件抽出する
    # 更新を押すごとにおすすめ内容が変わる仕様のため
    sql = 'entities.name LIKE? or entities.name LIKE? or entities.name LIKE?'
    @notes = Note
      .eager_load(:entities)
      .where(sql, "%#{entities[0].name}%", "%#{entities[1].name}%", "%#{entities[2].name}%")
      .includes([:user])
      .take(10)
      # .order("RANDOM()").limit(10) or take(10)か要検討
      byebug
  end
end
