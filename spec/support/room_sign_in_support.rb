module RoomSignInSupport
  def room_sign_in(_room)
    expect(page).to have_link('ルームに入る')
    visit sessions_path
    fill_in 'session[name]'
    fill_in 'session[password]'
    click_on('ルームに入る')
    expect(current_path).to eq root_path
  end
end
