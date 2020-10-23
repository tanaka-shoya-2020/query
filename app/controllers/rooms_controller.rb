class RoomsController < ApplicationController
  
  before_action :move_to_root_path, only: [:new, :create]
  
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
      flash[:success] = "ルームを作成しました"
      redirect_to root_path
    else
      flash.now[:danger] = "同一のルーム名が存在するか、パスワードが不正です"
      render :new
    end
  end



  private 
    def room_params
      params.require(:room).permit(:name, :password, :password_confirmation)
    end

    def move_to_root_path
      unless user_signed_in? 
        redirect_to root_path
      end
    end

end
