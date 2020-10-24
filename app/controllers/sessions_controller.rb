class SessionsController < ApplicationController
  before_action :move_to_root_path, only: [:new, :create, :destroy]

  def new
  end

  def create
    room = Room.find_by(name: params[:session][:name])
    if room&.authenticate(params[:session][:password])
      log_in room
      flash[:success] = 'ルームに入室しました'
      redirect_to root_path
    else
      flash.now[:danger] = '名前かパスワードが正しくありません'
      render :new
    end
  end

  def destroy
    log_out
    flash[:success] = 'ルームを退出しました'
    redirect_to root_path
  end

  private

  def move_to_root_path
    returun if user_signed_in?
    flash[:danger] = 'ログインが必要です'
    redirect_to root_path
  end
end
