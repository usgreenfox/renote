class BookmarksController < ApplicationController
  before_action :set_note, only: %i(create destroy)

  def create
    current_user.bookmarks.find_or_create_by(note_id: @note.id)
    redirect_to request.referer
  end

  def destroy
    bookmark = current_user.bookmarks.find_by(note_id: @note.id)
    bookmark.destroy if bookmark.present?
    redirect_to request.referer
  end

  private
  def set_note
    @note = Note.find(params[:note_id])
  end
end
