class RecommendsController < ApplicationController
  def index
    user_entity = current_user.entities.order(salience: :DESC).first
    user_entity = nil
    @notes = Note.eager_load(:entities).where('entities.name LIKE?', "#{user_entity.name}").includes([:user])
  end
end
