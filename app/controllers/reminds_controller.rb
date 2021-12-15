class RemindsController < ApplicationController
  before_action :set_note, only: %i(create destroy update)
  before_action :set_remind, only: %i(destroy update)
  before_action :authenticate_user!

  def create
    current_user.reminds.find_or_create_by(note_id: @note.id)
    # redirect_to request.referer
  end

  def destroy
    @remind.destroy if @remind.present?
    # redirect_to request.referer
  end

  def update
    @remind.update(remind_params)
    redirect_to request.referer
  end

  private
  def set_note
    @note = Note.find(params[:note_id])
  end

  def set_remind
    @remind = current_user.reminds.find_by(note_id: @note.id)
  end

  def remind_params
    params.require(:remind).permit(:first_notice, :second_notice, :third_notice)
  end
end
