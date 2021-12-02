class NotesController < ApplicationController
  before_action :set_note, only:[:show, :edit, :update, :destroy]

  def index
    @notes = Note.all
  end

  def show
    @comment = Comment.new
  end

  def new
    @note = Note.new
  end

  def edit
    @tags = @post.tags.pluck(:name) unless @post.tags.nil?
    @tags = @tags.join(" ")
  end

  def create
    @note = current_user.notes.new(note_params)
    tag_list = params[:note][:name].split(nil)
    if @note.save
      @post.save_tag(tag_list)
      redirect_to note_path(@note)
    else
      render 'new'
    end
  end

  def update
    tag_list = params[:note][:name].split(nil)
    if @note.update(note_params)
      @post.save_tag(tag_list)
      redirect_to note_path(@note)
    else
      render 'edit'
    end
  end

  def destroy
    @note.destroy if current_user.id == @note.user.id
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
