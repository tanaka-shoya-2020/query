class UsersController < ApplicationController
  before_action :move_to_root_path, only: [:show]
  def show
    @articles = Article.where(user_id: params[:id]).paginate(page: params[:page], per_page: 10).order('created_at DESC')
  end

  private

  def move_to_root_path
    @user = User.find(params[:id])
    return if user_signed_in? && current_user.id == @user.id

    flash[:danger] = '他人の詳細ページを閲覧することはできません'
    redirect_to root_path
  end
end
