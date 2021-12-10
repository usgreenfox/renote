class SearchesController < ApplicationController
  def index
    @model = params[:model]
    @keyword = params[:keyword]

    @results = search_for(@model, @keyword)
  end

  def search_for(model, keyword)
    # タグのバッジをクリック時、完全一致
    if model == 'tag'
      Tag.find_by("name =?", keyword).notes
    # 検索窓に入力時、部分一致
    elsif model == 'note'
      Note.eager_load(:tags).where("title LIKE? or body LIKE? or tags.name LIKE?", "%#{keyword}%", "%#{keyword}%", "%#{keyword}%")
    end
  end
end
