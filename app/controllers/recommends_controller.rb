class RecommendsController < ApplicationController
  def index
    # develop => SQLite, production => MySQLのため
    rand = Rails.env.production? ? "RAND()" : "RANDOM()"

    entities = User.entities_of(current_user)
    if entities.present?
      # 対象エンティティをもつノートを取得し、ランダムに10件抽出する
      i = entities.count - 1
      @notes = Note.eager_load(:entities).where('entities.name IN (?)', entities[0..i]).order(rand).limit(10).includes([:user])
    else
      # ユーザーがノートを作成していない場合、ユーザーはエンティティを持たないので
      # 全ノートからランダムで表示する
      @notes = Note.order(rand).limit(10).includes([:user])
    end
  end
end
