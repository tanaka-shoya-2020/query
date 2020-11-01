require 'rails_helper'

RSpec.describe 'コメント投稿機能', type: :system do
  before do
    @comment = FactoryBot.build(:comment)
    @article = FactoryBot.create(:article)
    @room    = FactoryBot.create(:room)
    @user    = FactoryBot.create(:user)
    @another_user = FactoryBot.create(:user)
  end

  context 'コメント投稿ができるとき', :js do
    it 'ログインとルームに入室をした状態で、自分の記事がルーム内にあるときにコメントを投稿することができる' do
      # 投稿したユーザーでログインする
      sign_in(@article.user)
      # 投稿したルームに入室する
      room_sign_in(@article.room)
      # 投稿詳細画面に遷移する
      visit article_path(@article)
      # 投稿詳細画面にコメント投稿というテキストがあることを確認する
      expect(page).to have_content('コメント投稿')
      # コメントを入力する
      fill_in_editor_field @comment.comment.to_s
      # コメントが画面に表示されていることを確認する
      expect(page).to have_editor_display text: @comment.comment.to_s
      # コメントを投稿するボタンをクリックするとコメントモデルのカウント数が1増えることを確認する
      expect { click_on('コメントを投稿する') }.to change { Comment.count }.by(1)
      # 投稿詳細画面へ遷移することを確認する
      expect(current_path).to eq article_path(@article)
      # コメント投稿に成功したメッセージが表示されることを確認する
      expect(page).to have_content('コメントが投稿されました')
      # 投稿したコメントがページに表示されていることを確認する
      expect(page).to have_content(@comment.comment)
    end

    it 'ログインとルームに入室をした状態で、他人の記事がルーム内にあるときにコメントを投稿することができる' do
      # 投稿していないユーザーでログインする
      sign_in(@another_user)
      # 投稿したルームに入室する
      room_sign_in(@article.room)
      # 投稿詳細画面に遷移する
      visit article_path(@article)
      # 投稿詳細画面にコメント投稿というテキストがあることを確認する
      expect(page).to have_content('コメント投稿')
      # コメントを入力する
      fill_in_editor_field @comment.comment.to_s
      # コメントが画面に表示されていることを確認する
      expect(page).to have_editor_display text: @comment.comment.to_s
      # コメントを投稿するボタンをクリックするとコメントモデルのカウント数が1増えることを確認する
      expect { click_on('コメントを投稿する') }.to change { Comment.count }.by(1)
      # 投稿詳細画面へ遷移することを確認する
      expect(current_path).to eq article_path(@article)
      # コメント投稿に成功したメッセージが表示されることを確認する
      expect(page).to have_content('コメントが投稿されました')
      # 投稿したコメントがページに表示されていることを確認する
      expect(page).to have_content(@comment.comment)
    end
  end

  context 'コメント投稿ができないとき' do
    it 'ログインとルームに入室をした状態ではあるが、不正な情報を投稿しようとしたとき' do
      # 投稿したユーザーでログインする
      sign_in(@article.user)
      # 投稿したルームに入室する
      room_sign_in(@article.room)
      # 投稿詳細画面に遷移する
      visit article_path(@article)
      # 投稿詳細画面にコメント投稿というテキストがあることを確認する
      expect(page).to have_content('コメント投稿')
      # コメントを入力しないまま投稿するボタンをクリックするとコメントモデルのカウント数が変わらないことを確認する
      expect { click_on('コメントを投稿する') }.to change { Comment.count }.by(0)
      # 投稿詳細画面へ戻されることを確認する
      expect(current_path).to eq article_comments_path(@article)
      # コメント投稿に失敗したメッセージが表示されることを確認する
      expect(page).to have_content('コメントが投稿されませんでした')
    end

    it '削除された記事に対してコメントを投稿しようとしたとき' do
    end

    it 'ログインをせずにコメントを投稿しようとしたとき' do
      # 投稿詳細画面に遷移する
      visit article_path(@article)
      # 投稿詳細画面に遷移せずログイン画面に戻されることを確認する
      expect(current_path).to eq new_user_session_path
      # 戻された時にエラーメッセージが表示されることを確認する
      expect(page).to have_content('ログインが必要です')
    end

    it 'ログインはしたものの、ルームに入室していない状態でコメントを投稿しようとしたとき' do
      # 投稿したユーザーでログインする
      sign_in(@article.user)
      # 投稿詳細画面に遷移する
      visit article_path(@article)
      # 投稿詳細画面に遷移せずルーム入室画面に戻されることを確認する
      expect(current_path).to eq new_session_path
      # 戻された時にエラーメッセージが表示されることを確認する
      expect(page).to have_content('ルームに入室してください')
    end
  end

  private

  # codemirrorの中にtextを入力する
  def fill_in_editor_field(text)
    within '.CodeMirror' do
      # Click makes CodeMirror element active:
      current_scope.click

      # Find the hidden textarea:
      field = current_scope.find('textarea', visible: false)

      # Mimic user typing the text:
      field.send_keys text
    end
  end

  # codemirrorの中のテキストを出力する
  def have_editor_display(options)
    editor_display_locator = '.CodeMirror-code'
    have_css(editor_display_locator, options)
  end
end

RSpec.describe 'コメント編集機能', type: :system do
  before do
    @comment = FactoryBot.create(:comment)
    @room    = FactoryBot.create(:room)
    @user    = FactoryBot.create(:user)
  end

  context 'コメントの編集ができるとき' do
    it 'ログインとルームに入室をした状態で、記事がルーム内にあるとき自身のコメントを編集することができる' do
      # 投稿したユーザーでログインする
      sign_in(@comment.user)
      # 投稿したルームに入室する
      room_sign_in(@comment.article.room)
      # 投稿詳細画面に遷移する
      visit article_path(@comment.article)
      # 投稿詳細画面に編集するというボタンがあることを確認する
      expect(page).to have_content('編集する')
      # コメントの編集画面に遷移する
      visit edit_article_comment_path(@comment.article, @comment)
      # コメントを入力する
      fill_in_editor_field 'foobarbarfoo'
      # コメントが画面に表示されていることを確認する
      expect(page).to have_editor_display text: 'foobarbarfoo'
      # コメントを更新するボタンをクリックしてもコメントモデルのカウント数が変わらないことを確認する
      expect { click_on('コメントを更新する') }.to change { Comment.count }.by(0)
      # 投稿詳細画面へ遷移することを確認する
      expect(current_path).to eq article_path(@comment.article)
      # コメント投稿に成功したメッセージが表示されることを確認する
      expect(page).to have_content('コメントが変更されました')
      # 投稿したコメントがページに表示されていることを確認する
      expect(page).to have_content('foobarbarfoo')
    end
  end

  context 'コメント編集ができないとき' do
    it 'ログインとルームに入室をした状態ではあるが、不正な情報で投稿しようとしたとき' do
      # 投稿したユーザーでログインする
      sign_in(@comment.user)
      # 投稿したルームに入室する
      room_sign_in(@comment.article.room)
      # 投稿詳細画面に遷移する
      visit article_path(@comment.article)
      # 投稿詳細画面に編集するというボタンがあることを確認する
      expect(page).to have_content('編集する')
      # コメントの編集画面に遷移する
      visit edit_article_comment_path(@comment.article, @comment)
      # 不正なコメントを入力する
      text = 'a' * 1000
      fill_in_editor_field(text)
      # コメントを更新するボタンを押してもコメントモデルの数が変化しないことを確認する
      expect { click_on('コメントを更新する') }.to change { Comment.count }.by(0)
      # コメント編集画面に戻されることを確認する
      expect(current_path).to eq article_comment_path(@comment.article, @comment)
    end

    it '他人のコメントを編集しようとしたとき' do
      # 投稿したユーザーでログインする
      sign_in(@user)
      # 投稿したルームに入室する
      room_sign_in(@comment.article.room)
      # 投稿詳細画面に遷移する
      visit article_path(@comment.article)
      # 投稿詳細画面に編集するというボタンがないことを確認する
      expect(page).to have_no_link('編集する')
      # コメントの編集画面に遷移する
      visit edit_article_comment_path(@comment.article, @comment)
      # 編集画面に遷移できずに詳細画面に戻されることを確認する
      expect(current_path).to eq article_path(@comment.article)
      # 戻された時にエラーメッセージが表示されることを確認する
      expect(page).to have_content('自身のコメントではありません')
    end

    it 'ログインをせずにコメントを編集しようとしたとき' do
      # コメントの編集画面に遷移する
      visit edit_article_comment_path(@comment.article, @comment)
      # 編集画面に遷移できずにログイン画面に遷移することを確認する
      expect(current_path).to eq new_user_session_path
      # 戻された時にエラーメッセージが表示されることを確認する
      expect(page).to have_content('ログインが必要です')
    end

    it 'ログインはしたものの、ルームに入室していない状態でコメントを編集しようとしたとき' do
      # コメントをしたユーザーでログインする
      sign_in(@comment.user)
      # コメントの編集画面に遷移する
      visit edit_article_comment_path(@comment.article, @comment)
      # 編集画面に遷移できずにルーム入室画面に遷移することを確認する
      expect(current_path).to eq new_session_path
      # 戻された時にエラーメッセージが表示されることを確認する
      expect(page).to have_content('ルームに入室してください')
    end

    it 'ログインとルームの入室はしたが、投稿された記事のルームでないルームからコメントを編集しようとしたとき' do
      # コメントをしたユーザーでログインする
      sign_in(@comment.user)
      # コメントを投稿していないルームにログインする
      room_sign_in(@room)
      # コメントの編集画面に遷移する
      visit edit_article_comment_path(@comment.article, @comment)
      # 編集画面に遷移できずにルートページに遷移することを確認する
      expect(current_path).to eq root_path
      # 戻された時にエラーメッセージが表示されることを確認する
      expect(page).to have_content('ルームが異なるためコメントできません')
    end
  end

  private

  # codemirrorの中にtextを入力する
  def fill_in_editor_field(text)
    within '.CodeMirror' do
      # Click makes CodeMirror element active:
      current_scope.click

      # Find the hidden textarea:
      field = current_scope.find('textarea', visible: false)

      # Mimic user typing the text:
      field.send_keys text
    end
  end

  # codemirrorの中のテキストを出力する
  def have_editor_display(options)
    editor_display_locator = '.CodeMirror-code'
    have_css(editor_display_locator, options)
  end
end

RSpec.describe 'コメント削除機能', type: :system do
  before do
    @comment = FactoryBot.create(:comment)
    @room    = FactoryBot.create(:room)
    @user    = FactoryBot.create(:user)
  end

  context 'コメントの削除ができるとき' do
    it 'ログインとルームに入室をした状態で、記事がルーム内にあるときコメントを削除することができる' do
      # コメントをしたユーザーでログインする
      sign_in(@comment.user)
      # コメントをしたルームに入室する
      room_sign_in(@comment.article.room)
      # 投稿詳細画面に遷移する
      visit article_path(@comment.article)
      # 投稿一覧ページではコメントが存在することを確認する
      expect(page).to have_content(@comment.comment)
      # 投稿詳細画面に削除するというボタンがあることを確認する
      expect(page).to have_link('削除する')
      # 削除ボタンを押すと本当に削除しますかの警告文が表示され、OKを押すと記事が削除されることを確認する
      accept_alert do
        click_link '削除する'
      end
      # 削除された後、投稿一覧ページへ遷移することを確認する
      expect(current_path).to eq article_path(@comment.article)
      # 投稿一覧ページでは先ほど削除したコメントが存在しないことを確認する
      expect(page).to have_no_content(@comment)
      # 削除に成功したメッセージが表示されることを確認する
      expect(page).to have_content('削除されました')
    end
  end

  context 'コメント削除ができないとき' do
    it '他人のコメントを削除しようとしたとき' do
      # コメントをしていないユーザーでログインする
      sign_in(@user)
      # コメントをしたルームに入室する
      room_sign_in(@comment.article.room)
      # 投稿詳細画面に遷移する
      visit article_path(@comment.article)
      # 投稿一覧ページではコメントが存在することを確認する
      expect(page).to have_content(@comment.comment)
      # 投稿詳細画面に削除するというボタンがないことを確認する
      expect(page).to have_no_link('削除する')
    end

    it 'ログインをせずにコメントを削除しようとしたとき' do
      # 投稿詳細画面に遷移する
      visit article_path(@comment.article)
      # 詳細画面に遷移できずにログイン画面に戻されることを確認する
      expect(current_path).to eq new_user_session_path
      # 戻されたときにエラーメッセージが表示されることを確認する
      expect(page).to have_content('ログインが必要です')
    end

    it 'ログインはしたものの、ルームに入室していない状態でコメントを削除しようとしたとき' do
      sign_in(@comment.user)
      # 投稿詳細画面に遷移する
      visit article_path(@comment.article)
      # 詳細画面に遷移できずにログイン画面に戻されることを確認する
      expect(current_path).to eq new_session_path
      # 戻されたときにエラーメッセージが表示されることを確認する
      expect(page).to have_content('ルームに入室してください')
    end
  end
end
