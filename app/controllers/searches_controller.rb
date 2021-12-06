class SearchesController < ApplicationController
  def index
    model = params[:model]
    keyword = params[:keyword]
    
    @results = search_for(model, keyword)
  end
  
  def search_for(model, keyword)
    if model == 'tag'
      
    elsif model == 'note'
      Note.where("title LIKE? or body LIKE?", "%#{keyword}%", "%#{keyword}%")
    end
  end
end
