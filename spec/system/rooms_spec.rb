require 'rails_helper'

RSpec.describe 'ルーム作成機能', type: :system do
  before do
    @room = FactoryBot.build(:room)
    @user = FactoryBot.create(:user)
  end

  context 'ルームの新規作成ができるとき' do
    it 'ログインした状態で、正しい情報を入力すればルームの作成ができてトップページに遷移する' do
      # ログインする
      sign_in(@user)
      # ルームを作成するリンクが存在することを確認する
      expect(page).to have_link('ルームを作成する')
      # ルームを作成ページに遷移する
      visit new_room_path
      # 作成するための情報を入力する
      fill_in 'room[name]', with: @room.name
      fill_in 'room[password]', with: @room.password
      fill_in 'room[password_confirmation]', with: @room.password_confirmation
      # ルーム作成ボタンを押すとルームモデルのカウント数が1増えることを確認する
      expect { click_on('ルームを作成') }.to change { Room.count }.by(1)
      # トップページへ遷移することを確認する
      expect(current_path).to eq root_path
      # トップページにルーム作成が成功したことを表示するメッセージがあることを確認する
      expect(page).to have_content('ルームを作成しました')
      # トップページにルームを退室するボタンがあることを確認する
      expect(page).to have_link('ルームを退出する')
      # ルームを作成するボタンや、ルームに入室するボタンがないことを確認する
      expect(page).to have_no_link('ルームを作成する')
      expect(page).to have_no_link('ルームに入る')
    end
  end

  context 'ルームの新規作成ができないとき' do
    it '誤った情報ではルームの新規作成ができず作成画面に戻ってくる' do
      # ログインする
      sign_in(@user)
      # ルームを作成するリンクが存在することを確認する
      expect(page).to have_link('ルームを作成する')
      # ルームを作成ページに遷移する
      visit new_room_path
      # 作成するための情報を入力する
      fill_in 'room[name]', with: ''
      fill_in 'room[password]', with: @room.password
      fill_in 'room[password_confirmation]', with: @room.password_confirmation
      # ルームを作成するボタンを押してもルームモデルのカウント数が変わらないことを確認
      expect { click_on('ルームを作成') }.to change { Room.count }.by(0)
      # ルーム作成ページへ戻されることを確認する
      expect(current_path).to eq rooms_path
      # 戻された後にエラーメッセージが表示されていることを確認する
      expect(page).to have_content('同一のルーム名が存在するか、パスワードが不正です')
    end

    it 'ログインしていない状態でルームの新規作成画面に遷移しようとすると、ログイン画面に戻される' do
      # ログインしていない状態でルームの新規作成画面に遷移する
      visit new_room_path
      # ログインページに戻されることを確認する
      expect(current_path).to eq new_user_session_path
      # 戻された後にエラーメッセージが表示されていることを確認する
      expect(page).to have_content('ログインが必要です')
    end
  end
end

RSpec.describe 'ルーム入室機能', type: :system do
  before do
    @room = FactoryBot.create(:room)
    @user = FactoryBot.create(:user)
  end

  context 'ルームの入室ができるとき' do
    it 'ログインした状態で、正しい情報を入力すればルームに入室できてトップページに遷移する' do
      # ログインする
      sign_in(@user)
      # ルームの入室画面へ遷移する
      visit new_session_path
      # 入室するための情報を入力する
      fill_in 'session[name]', with: @room.name
      fill_in 'session[password]', with: @room.password
      # 入室するボタンを押す
      click_on('入室する')
      # ルートページへ遷移することを確認する
      expect(current_path).to eq root_path
      # トップページにルームに入室するのに成功したメッセージが表示されることを確認する
      expect(page).to have_content('ルームに入室しました')
    end
  end

  context 'ルームの入室ができないとき' do
    it '誤った情報ではルームの入室ができず入室画面に戻ってくる' do
      # ログインする
      sign_in(@user)
      # ルームの入室画面へ遷移する
      visit new_session_path
      # 入室するための情報を入力する
      fill_in 'session[name]', with: ''
      fill_in 'session[password]', with: @room.password
      # 入室するボタンを押す
      click_on('入室する')
      # ルームの入室画面へ戻されることを確認する
      expect(current_path).to eq sessions_path
      # 戻された後にエラーメッセージが表示されることを確認する
      expect(page).to have_content('名前かパスワードが正しくありません')
    end

    it 'ログインしていない状態でルームに入室しようとすると、入室できずにログインページへ戻ることを確認する' do
      # ルームの入室画面へ遷移する
      visit new_session_path
      # ログインページに戻されることを確認する
      expect(current_path).to eq new_user_session_path
      # 戻された後にエラーメッセージが表示されることを確認する
      expect(page).to have_content('ログインが必要です')
    end
  end
end
