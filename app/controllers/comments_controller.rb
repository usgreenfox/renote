class CommentsController < ApplicationController
  before_action :set_note, only: %i(create destroy)
  before_action :authenticate_user!

  def create
    @comment = current_user.comments.new(comment_params)
    if @comment.save
      redirect_to note_path(@note)
    else
      render 'notes/show'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy if current_user.id == @note.user_id
    redirect_to note_path(@note)
  end

  private
  def comment_params
    params.require(:comment).permit(:body, :note_id)
  end

  def set_note
    @note = Note.find(params[:note_id])
  end
end
