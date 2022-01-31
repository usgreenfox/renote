class NotesController < ApplicationController
  before_action :set_note, only: %i(show edit update destroy)
  before_action :authenticate_user!, except: %i(index show)

  def index
    @column = sort_column
    @direction = sort_direction
    @notes = Note.includes(:user).order(@column => @direction).page(params[:page])
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
    # エンティティの取得、登録
    @note.registration_entities
    if @note.save
      # sessionの初期化
      session[:note] = nil
      # タグの登録
      @note.save_tag(tag_list)
      # リマインドの作成
      current_user.reminds.find_or_create_by(note_id: @note.id)
      redirect_to note_path(@note), notice: 'ノートが作成されました'
    else
      # フォームから渡された値のみsessionに保存（user_id等は保存しない）
      session[:note] = @note.attributes.slice(*note_params.keys)
      flash[:alert] = @note.errors.full_messages
      redirect_to new_note_path
    end
  end

  def update
    tag_list = params[:note][:tag_name].split(nil)
    # エンティティの取得、更新
    @note.registration_entities
    if @note.update(note_params)
      @note.save_tag(tag_list)
      redirect_to note_path(@note), notice: 'ノートが更新されました'
    else
      flash[:alert] = @note.errors.full_messages
      redirect_to edit_note_path(@note)
    end
  end

  def destroy
    @note.destroy if current_user.id == @note.user.id
    redirect_to notes_path, notice: 'ノートが削除されました'
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
