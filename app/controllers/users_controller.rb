class UsersController < ApplicationController
  before_action :set_user, only: %i(show edit update)
  before_action :authenticate_user!, except: %i(index show)

  def index
    redirect_to new_user_registration_path
  end

  def show
    @notes = Note.includes(:user).where(user_id: @user.id).order(updated_at: :DESC).page(params[:page])
    @fav_notes = @user.fav_notes.page(params[:page])
  end

  def edit
    # 他ユーザーの情報を編集しようとすると、自身の編集ページにリダイレクトさせる。
    redirect_to edit_user_path(current_user.id) if @user.id != current_user.id
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "ユーザー情報が更新されました"
    else
      flash[:alert] = @user.errors.full_messages
      redirect_to edit_user_path(@user)
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
