class RecommendsController < ApplicationController
  def index
    @notes = Note.random_search(current_user.build_entities)
  end
end
