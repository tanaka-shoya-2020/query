module RoomSignInSupport
  def room_sign_in(room)
    expect(page).to have_link('ルームに入る')
    visit new_session_path
    fill_in 'session[name]', with: room.name
    fill_in 'session[password]', with: room.password
    click_on('入室する')
    expect(current_path).to eq root_path
  end
end
