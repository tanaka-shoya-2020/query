require 'rails_helper'

RSpec.describe Article, type: :model do
  
  before do
    @user = FactoryBot.create(:user)
    @room = FactoryBot.create(:room)
    @article = FactoryBot.build(:article, user_id: @user.id, room_id: @room.id)
  end

  describe '新規記事の作成' do
    context '新規投稿ができるとき' do
      it 'titleとtextが存在する時' do
        expect(@article).to be_valid
      end
      it 'titleが50文字以下の時' do
        @article.title = "a"*50
        @article.save
        expect(@article).to be_valid
      end
    end

    context '新規投稿が失敗する時' do
      it 'titleが存在しない時' do
        @article.title = ""
        @article.valid?
        expect(@article.errors.full_messages).to include("Title can't be blank")
      end

      it 'titleが51文字以上の時' do
        @article.title = "a"*51
        @article.valid?
        expect(@article.errors.full_messages).to include("Title is too long (maximum is 50 characters)")
      end

      it 'textが存在しない時' do
        @article.text = nil
        @article.valid?
        expect(@article.errors.full_messages).to include("Text can't be blank")
      end

      it 'userの紐付けがない時' do
        @article.user_id = nil
        @article.valid?
        expect(@article.errors.full_messages).to include("User can't be blank")
      end

      it 'roomの紐付けがない時' do
        @article.room_id = nil
        @article.valid?
        expect(@article.errors.full_messages).to include("Room can't be blank")
      end
    end
  end
end

