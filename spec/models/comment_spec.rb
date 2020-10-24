require 'rails_helper'

RSpec.describe Comment, type: :model do
  before do
    @comment = FactoryBot.build(:comment)
  end

  describe 'コメント投稿機能' do
    context 'コメント投稿ができるとき' do
      it 'コメントが存在する時' do
        expect(@comment).to be_valid
      end

      it 'コメントが200文字以内の時' do
        @comment.comment = 'a'*200
        expect(@comment).to be_valid
      end
    end

    context 'コメント投稿に失敗する時' do
      it 'コメントが存在しない時' do
        @comment.comment = nil
        @comment.valid?
        expect(@comment.errors.full_messages).to include("Comment can't be blank")
      end

      it 'コメントが201文字以上の時' do
        @comment.comment = 'a' * 201
        @comment.valid?
        expect(@comment.errors.full_messages).to include("Comment is too long (maximum is 200 characters)")
      end

      it 'userの紐付けがなくなった時' do
        @comment.user = nil
        @comment.valid?
        expect(@comment.errors.full_messages).to include("User must exist")
      end

      it 'roomの紐付けがなくなった時' do
        @comment.room = nil
        @comment.valid?
        expect(@comment.errors.full_messages).to include("Room must exist")
      end

      it 'articleの紐付けがなくなった時' do
        @comment.article = nil
        @comment.valid?
        expect(@comment.errors.full_messages).to include("Article must exist")
      end
    end
  end
end
