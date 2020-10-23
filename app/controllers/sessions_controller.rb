class SessionsController < ApplicationController
  def new
    
  end

  def create
    room = Room.find_by(name: params[:session][:name])
    if room && room.authenticate(params[:session][:password])
      log_in room
      flash[:success] = "ルームに入室しました"
      redirect_to root_path
    else
      flash.now[:danger] = '名前かパスワードが正しくありません'
      render :new
    end
  end

  def destroy
    log_out
    flash[:success] = "ルームを退出しました"
    redirect_to root_path
  end
end
