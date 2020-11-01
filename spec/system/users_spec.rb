require 'rails_helper'

RSpec.describe 'ユーザー新規登録機能', type: :system do
  before do
    @user = FactoryBot.build(:user)
  end

  context 'ユーザー新規登録ができるとき' do
    it '正しい情報を入力すればユーザー新規登録ができてトップページに遷移する' do
      # トップページに遷移する
      visit root_path
      # トップーページにサインアップページへ遷移するボタンがあることを確認する
      expect(page).to have_link('新規登録')
      # 新規登録ページへ遷移する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'user[nickname]', with: @user.nickname
      fill_in 'user[email]', with: @user.email
      fill_in 'user[password]', with: @user.password
      fill_in 'user[password_confirmation]', with: @user.password_confirmation
      # サインアップボタンを押すとユーザーモデルのカウントが1増える
      expect { click_on('サインアップ') }.to change { User.count }.by(1)
      # トップページへ遷移することを確認する
      expect(current_path).to eq root_path
      # トップページにサインインが成功した文字が表示されることを確認する
      expect(page).to have_content('Welcome! You have signed up successfully.')
      # トップページにログアウトボタンが表示されるいことを確認する
      expect(page).to have_link('ログアウトする')
      # サインアップボタンへ遷移するボタンや、ログインページに遷移するボタンが存在しないことを確認する
      expect(page).to have_no_link('新規登録')
      expect(page).to have_no_link('ログインする')
    end
  end
  context 'ユーザー新規登録ができないとき' do
    it '誤った情報ではユーザー新規登録ができずに新規登録ページへ戻ってくる' do
      # トップページに移動する
      visit root_path
      # トップページにサインアップページへ遷移するボタンがあることを確認する
      expect(page).to have_link('新規登録')
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'user[nickname]', with: @user.nickname
      fill_in 'user[email]', with: @user.email
      fill_in 'user[password]', with: ''
      fill_in 'user[password_confirmation]', with: ''
      # サインアップボタンを押してもユーザーモデルのカウント数が変化しないことを確認する
      expect { click_on('サインアップ') }.to change { User.count }.by(0)
      # 新規登録ページへ戻されることを確認する
      expect(current_path).to eq user_registration_path
    end
  end
end

RSpec.describe 'ユーザーログイン機能', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end

  context 'ログインができるとき' do
    it '保存されているユーザーの情報と合致すればログインができる' do
      # トップページに移動する
      visit root_path
      # トップページにログインページへ遷移するボタンがあることを確認する
      expect(page).to have_link('ログインする')
      # ログインページへ遷移する
      visit new_user_session_path
      # 正しいユーザー情報を入力する
      fill_in 'user[email]', with: @user.email
      fill_in 'user[password]', with: @user.password
      # ログインボタンを押す
      click_on('ログイン')
      # トップページへ遷移することを確認する
      expect(current_path).to eq root_path
      # トップページにサインインが成功した文字が表示されることを確認する
      expect(page).to have_content('Signed in successfully.')
      # ログアウトボタンが表示されることを確認する
      expect(page).to have_link('ログアウトする')
      # サインアップページへ遷移するボタンやログインページへ遷移するボタンが表示されていないことを確認する
      expect(page).to have_no_link('新規登録')
      expect(page).to have_no_link('ログインする')
    end
  end

  context 'ログインができないとき' do
    it '保存されているユーザーの情報と合致しないとログインができない' do
      # トップページに移動する
      visit root_path
      # トップページにログインページへ遷移するボタンがあることを確認する
      expect(page).to have_content('ログインする')
      # ログインページへ遷移する
      visit new_user_session_path
      # ユーザー情報を入力する
      fill_in 'user[email]', with: ''
      fill_in 'user[password]', with: @user.password
      # ログインボタンを押す
      click_on('ログイン')
      # ログインページへ戻されることを確認する
      expect(current_path).to eq user_session_path
    end
  end
end
