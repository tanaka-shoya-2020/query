module SessionsHelper
  def log_in(room)
    session[:room_id] = room.id
  end

  def room_logged_in?
    !current_room.nil?
  end

  def log_out
    session.delete(:room_id)
    @current_room = nil
  end

  def current_room
    @current_room ||= Room.find_by(id: session[:room_id]) if session[:room_id]
  end
end
