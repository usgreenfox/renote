class NotesController < ApplicationController
  before_action :set_note, only: %i(show edit update destroy)
  before_action :authenticate_user!, except: %i(index show)

  def index
    @column = sort_column
    @direction = sort_direction
    @notes = Note.all.order(@column => @direction)
  end

  def show
    if @note.in_private == true && @note.user_id != current_user.id
      redirect_to notes_path
    else
      @comments = @note.comments.all
      @comment = Comment.new
    end
  end

  def new
    @note = Note.new
  end

  def edit
    @tags = @note.tags.pluck(:name) unless @note.tags.nil?
    @tags = @tags.join(" ")
  end

  def create
    @note = current_user.notes.new(note_params)
    tag_list = params[:note][:tag_name].split(nil)
    if @note.save
      #タグの登録
      @note.save_tag(tag_list)
      #リマインドの作成
      current_user.reminds.find_or_create_by(note_id: @note.id)
      redirect_to note_path(@note), notice: "ノートが作成されました"
    else
      render 'new'
    end
  end

  def update
    tag_list = params[:note][:tag_name].split(nil)
    if @note.update(note_params)
      @note.save_tag(tag_list)
      redirect_to note_path(@note), notice: "ノートが更新されました"
    else
      render 'edit'
    end
  end

  def destroy
    @note.destroy if current_user.id == @note.user.id
    redirect_to notes_path, notice: "ノートが削除されました"
  end


  private
  def note_params
    params.require(:note).permit(:title, :body, :in_private)
  end

  def set_note
    @note = Note.find(params[:id])
  end

  def sort_column
    params[:column].present? ? params[:column] : 'updated_at'
  end

  def sort_direction
    params[:direction].present? ? params[:direction] : :DESC
  end
end
