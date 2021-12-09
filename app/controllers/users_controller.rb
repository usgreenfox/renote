class UsersController < ApplicationController
  before_action :set_user, only:[:show, :edit, :update]

  def show
  end

  def edit
    # 他ユーザーの情報を編集しようとすると、自身の編集ページにリダイレクトさせる。
    redirect_to edit_user_path(current_user.id) if @user.id != current_user.id
  end

  def update
    @user.update(user_params) ? (redirect_to user_path(@user)) : (render 'edit')
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
