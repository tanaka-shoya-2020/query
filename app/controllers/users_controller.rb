class UsersController < ApplicationController
  
  before_action :move_to_root_path, only: [:show]
  def show
    @user = User.find(params[:id])
    @articles = @user.articles
  end

  private

    def move_to_root_path
      @user = User.find(params[:id])
      unless user_signed_in? && current_user.id == @user.id
        flash[:danger] = "他人の詳細ページを閲覧することはできません"
        redirect_to root_path
      end
    end
end
