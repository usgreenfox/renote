class NotesController < ApplicationController
  before_action :set_note, only:[:show, :edit, :update, :destroy]

  def index
    @note = Note.all
  end

  def show
  end

  def new
    @note = Note.new
  end

  def edit
  end

  def create
    @note = current_user.notes.new(note_params)
    if @note.save
      redirect_to note_path(@note)
    else
      render 'new'
    end
  end

  def update
    if @note.update(note_params)
      redirect_to note_path(@note)
    else
      render 'edit'
    end
  end

  def destroy
    @note.destroy
    redirect_to notes_path
  end

  private
  def note_params
    params.require(:note).permit(:title, :body)
  end

  def set_note
    @note = Note.find(params[:id])
  end
end
