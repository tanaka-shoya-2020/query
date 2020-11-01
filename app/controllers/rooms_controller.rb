class RoomsController < ApplicationController
  before_action :move_to_sign_in, only: [:new, :create]

  def index
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    if @room.valid?
      @room.save
      log_in @room
      flash[:success] = 'ルームを作成しました'
      redirect_to root_path
    else
      flash.now[:danger] = '同一のルーム名が存在するか、パスワードが不正です'
      render :new
    end
  end

  private

  def room_params
    params.require(:room).permit(:name, :password, :password_confirmation)
  end

  def move_to_sign_in
    return if user_signed_in?

    flash[:danger] = 'ログインが必要です'
    redirect_to new_user_session_path
  end
end
