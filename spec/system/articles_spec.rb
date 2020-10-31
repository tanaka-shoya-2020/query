require 'rails_helper'

RSpec.describe '新規投稿機能', type: :system do
  before do
    @article = FactoryBot.build(:article)
    @room    = FactoryBot.create(:room)
    @user    = FactoryBot.create(:user)
  end

  context '記事の新規投稿ができるとき' do
    it 'ログインとルームに入室をした状態で、正しい情報を記入すると投稿できる' do
      # ログインする
      sign_in(@user)
      # ルームに入室する
      room_sign_in(@room)
      # 新規投稿ページへ遷移する
      visit new_article_path
      # 投稿ページに正しい情報を入力する
      fill_in 'article[title]', with: @article.title
      # 記事を投稿するボタンを押すとarticleモデルのカウント数が1増えることを確認する
      expect { click_on('投稿する') }.to change { Article.count }.by(1)
      # 投稿一覧ページへ遷移することを確認する
      expect(current_path).to eq articles_path
      # 一覧ページに投稿に成功したメッセージが表示されることを確認する
      expect(page).to have_content('記事が保存されました')
    end
  end

  context '記事の新規投稿に失敗するとき' do
    it 'ログインとルームの入室をしたが、情報が不正であった場合' do
      # ログインする
      sign_in(@user)
      # ルームに入室する
      room_sign_in(@room)
      # 新規投稿ページへ遷移する
      visit new_article_path
      # 投稿ページに不正な情報を入力する
      fill_in 'article[title]', with: ''
      # 記事を投稿するボタンを押してもarticleモデルのカウント数が変わらないことを確認する
      expect { click_on('投稿する') }.to change { Article.count }.by(0)
      # 新規投稿ページへ戻されることを確認する
      expect(current_path).to eq articles_path
      # 戻された時にエラーメッセージが表示されることを確認する
      expect(page).to have_content('記事が保存されませんでした')
    end

    it 'ログインをせずに、新規投稿を行おうとしたとき' do
      # 新規投稿ページへ遷移する
      visit new_article_path
      # 遷移できずにログインページへ戻されることを確認する
      expect(current_path).to eq new_user_session_path
      # 戻された時にエラーメッセージが表示されることを確認する
      expect(page).to have_content('ログインが必要です')
    end

    it 'ログインはしたが、ルームに入室せずに新規投稿を行おうしたとき' do
      # ログインする
      sign_in(@user)
      # 新規投稿ページへ遷移する
      visit new_article_path
      # 遷移できずにルーム入室画面へ戻されることを確認する
      expect(current_path).to eq new_session_path
      # 戻されたときにエラーメッセージが表示されることを確認する
      expect(page).to have_content('ルームに入室してください')
    end
  end
end

RSpec.describe '投稿閲覧機能', type: :system do
  before do
    @article = FactoryBot.build(:article)
    @room    = FactoryBot.create(:room)
    @user    = FactoryBot.create(:user)
  end

  context '記事の一覧を閲覧できるとき' do
    it 'ログインとルームの入室をしたのちに、閲覧画面に遷移する' do
      # ログインする
      sign_in(@user)
      # ルームに入室する
      room_sign_in(@room)
      # 投稿一覧ページへ遷移する
      visit articles_path
      # 投稿一覧の文字が表示されていることを確認する
      expect(page).to have_content('投稿一覧')
    end
  end

  context '記事の一覧を閲覧できないとき' do
    it 'ログインをせずに、閲覧を行おうとしたとき' do
      # 投稿一覧ページへ遷移する
      visit articles_path
      # 投稿一覧ページへ遷移せずログイン画面に戻されることを確認する
      expect(current_path).to eq new_user_session_path
      # 戻されたときにエラーメッセージが表示されることを確認する
      expect(page).to have_content('ログインが必要です')
    end

    it 'ログインはしたが、ルームを入室せずに記事一覧の閲覧を行おうしたとき' do
      # ログインする
      sign_in(@user)
      # 投稿一覧ページへ遷移する
      visit articles_path
      # 投稿一覧ページへ遷移せずルーム入室画面に戻されることを確認する
      expect(current_path).to eq new_session_path
      # 戻されたときにエラーメッセージが表示されることを確認する
      expect(page).to have_content('ルームに入室してください')
    end
  end
end

RSpec.describe '投稿編集機能', type: :system do
  before do
    @article = FactoryBot.create(:article)
    @room    = FactoryBot.create(:room)
    @user    = FactoryBot.create(:user)
    @another_room = FactoryBot.create(:room)
    @another_user = FactoryBot.create(:user)
  end

  context '記事の編集ができるとき' do
    it 'ログインとルーム入室をした後、投稿した記事が自分のものであった場合' do
      # 投稿したユーザーでログインする
      sign_in(@article.user)
      # 投稿したルームに入室する
      room_sign_in(@article.room)
      # 編集画面に遷移する
      visit edit_article_path(@article)
      # 現在のページが編集画面であることを確認する
      expect(current_path).to eq edit_article_path(@article)
      # 情報を変更する
      fill_in 'article[title]', with: 'foobar'
      # 編集するボタンを押しても、articleモデルの数が変わらないことを確認する
      expect { click_on('編集する') }.to change { Article.count }.by(0)
      # 投稿詳細ページへ遷移することを確認する
      expect(current_path).to eq article_path(@article)
      # 編集に成功したときにメッセージが表示されることを確認する
      expect(page).to have_content('記事を編集しました')
    end
  end

  context '記事の編集ができないとき' do
    it '投稿した記事のユーザーがログインをし、投稿したでルーム入室をしたが、編集したときの情報が不正であるとき' do
      # 投稿したユーザーでログインする
      sign_in(@article.user)
      # 投稿したルームに入室する
      room_sign_in(@article.room)
      # 編集画面に遷移する
      visit edit_article_path(@article)
      # 現在のページが編集画面であることを確認する
      expect(current_path).to eq edit_article_path(@article)
      # 情報を変更する
      fill_in 'article[title]', with: ''
      # 編集するボタンを押しても、articleモデルの数が変わらないことを確認する
      expect { click_on('編集する') }.to change { Article.count }.by(0)
      # 編集画面へ戻されることを確認する
      expect(current_path).to eq article_path(@article)
      # 戻されたときにエラーメッセージが表示されることを確認する
      expect(page).to have_content('記事の編集に失敗しました')
    end

    it 'ログインとルーム入室をしたが、投稿した記事が自分のものでなかった場合' do
      # 投稿していない別のユーザーでログインする
      sign_in(@another_user)
      # ルームに入室する
      room_sign_in(@article.room)
      # 編集画面に遷移する
      visit edit_article_path(@article)
      # 編集画面に遷移できずに、ルートページへ戻ってくることを確認する
      expect(current_path).to eq root_path
      # 戻されたときにエラーメッセージが表示されることを確認する
      expect(page).to have_content('自身の投稿ではありません')
    end

    it 'ログインと入室をしたが、入室したルームが投稿したルームでなかったとき' do
      # 記事を投稿したユーザーでログインする
      sign_in(@article.user)
      # 記事を投稿していない別のルームに入室する
      room_sign_in(@another_room)
      # 編集画面に遷移する
      visit edit_article_path(@article)
      # 編集画面に遷移できずに、ルートページへ戻ってくることを確認する
      expect(current_path).to eq root_path
      # 戻った時にエラーメッセージが表示されることを確認する
      expect(page).to have_content('その記事はこのルームのものではないため、編集、削除はできません')
    end

    it 'ログインをせずに、編集を行おうとしたとき' do
      # 編集画面に遷移する
      visit edit_article_path(@article)
      # 編集画面へ遷移できずに、ログインページへ戻ってくることを確認する
      expect(current_path).to eq new_user_session_path
      # 戻った時にエラーメッセージが表示されることを確認する
      expect(page).to have_content('ログインが必要です')
    end

    it 'ログインはしたが、ルームに入室せずに記事の編集を行おうしたとき' do
      # ログインする
      sign_in(@user)
      # 編集画面に遷移する
      visit edit_article_path(@article)
      # 編集画面へ遷移できずに、ルーム入室ページへ戻ってくることを確認する
      expect(current_path).to eq new_session_path
      # 戻った時にエラーメッセージが表示されることを確認する
      expect(page).to have_content('ルームに入室してください')
    end
  end
end

RSpec.describe '投稿削除機能', type: :system do
  before do
    @article = FactoryBot.create(:article)
    @room    = FactoryBot.create(:room)
    @user    = FactoryBot.create(:user)
    @another_room = FactoryBot.create(:room)
    @another_user = FactoryBot.create(:user)
  end

  context '記事の削除ができるとき' do
    it 'ログインとルーム入室をした後、投稿した記事が自分のものであった場合' do
      # 記事を投稿したユーザーでログインする
      sign_in(@article.user)
      # 記事を投稿したルームに入室する
      room_sign_in(@article.room)
      # 記事の詳細ページに遷移する
      visit article_path(@article)
      # 詳細ページに削除するボタンがあることを確認する
      expect(page).to have_link('記事を削除する')
      # 削除ボタンを押すと本当に削除しますかの警告文が表示され、OKを押すと記事が削除されることを確認する
      accept_alert do
        click_link '記事を削除する'
      end
      # 削除された後、投稿一覧ページへ遷移することを確認する
      expect(current_path).to eq articles_path
      # 投稿一覧ページでは先ほど削除した記事が存在しないことを確認する
      expect(page).to have_no_content(@article)
      # 削除に成功したときのメッセージが表示されていることを確認する
      expect(page).to have_content('削除に成功しました')
    end
  end

  context '記事の削除ができないとき' do
    it 'ログインと記事を投稿したルーム入室をしたが、投稿した記事が自分のものでなかった場合' do
      # 投稿したユーザーではないユーザーでログインする
      sign_in(@another_user)
      # 記事を投稿したルームに入室する
      room_sign_in(@article.room)
      # 記事の詳細ページに遷移する
      visit article_path(@article)
      # 詳細ページに削除ボタンがないことを確認する
      expect(page).to have_no_link('記事を削除する')
    end

    it '記事を投稿したユーザーでログインをしたが、投稿したルームでなかったとき' do
      # 投稿したユーザーでログインする
      sign_in(@article.user)
      # 記事を投稿していないルームに入室する
      room_sign_in(@another_room)
      # 記事の詳細ページに遷移する
      visit article_path(@article)
      # 詳細ページに遷移できず、ルートページへ戻されることを確認する
      expect(current_path).to eq root_path
      # 戻ったときにエラーメッセージが表示されることを確認する
      expect(page).to have_content('その記事はこのルームのものではないため、編集、削除はできません')
    end

    it 'ログインをせずに、削除を行おうとしたとき' do
      # 記事の詳細ページに遷移する
      visit article_path(@article)
      # 遷移できずに、ログインページへ戻されることを確認する
      expect(current_path).to eq new_user_session_path
      # 戻った時にエラーメッセージが表示されることを確認する
      expect(page).to have_content('ログインが必要です')
    end

    it '記事を投稿したユーザーでログインはしたが、ルームに入室せずに記事の削除を行おうしたとき' do
      # 記事を投稿したユーザーでログインをする
      sign_in(@article.user)
      # 記事の詳細ページに遷移する
      visit article_path(@article)
      # 遷移できずに、ルーム入室ページへ戻されることを確認する
      expect(current_path).to eq new_session_path
      # 戻った時にエラーメッセージが表示されることを確認する
      expect(page).to have_content('ルームに入室してください')
    end
  end
end
