class UsersController < ApplicationController
  before_action :set_user, only:[:show, :edit, :update]
  before_action :authenticate_user!, except: :show

  def show
  end

  def edit
    # 他ユーザーの情報を編集しようとすると、自身の編集ページにリダイレクトさせる。
    redirect_to edit_user_path(current_user.id) if @user.id != current_user.id
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "ユーザー情報が更新されました"
    else
      render 'edit'
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
