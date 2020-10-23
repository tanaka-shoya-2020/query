require 'rails_helper'

RSpec.describe Room, type: :model do
  before do
    @room = FactoryBot.build(:room)
  end

  describe 'ルーム作成' do
    context 'ルームが作成できるとき' do
      it 'nameが存在し、 password, password_confirmationが6文字以上の英数字であるとき' do
        expect(@room).to be_valid
      end
      it 'nameが20文字以下の時' do
        @room.name = "a"*20
        expect(@room).to be_valid
      end
    end

    context 'ルームが作成できないとき' do
      it 'nameが空だと登録できない' do
        @room.name = nil
        @room.valid?
        expect(@room.errors.full_messages).to include("Name can't be blank")
      end

      it 'nameが重複すると登録できない' do
        @room.save
        @another_room = FactoryBot.build(:room)
        @another_room.name = @room.name
        @another_room.valid?
        expect(@another_room.errors.full_messages).to include("Name has already been taken")
      end

      it 'nameが21文字以上だと登録できない' do
        @room.name = "a"*21
        @room.valid?
        expect(@room.errors.full_messages).to include("Name is too long (maximum is 20 characters)")
      end

      it 'passwordが空だと登録できない' do
        @room.password = nil
        @room.password_confirmation = nil
        @room.valid?
        expect(@room.errors.full_messages).to include("Password can't be blank")
      end

      it 'passwordが5文字以下だと登録できない' do
        @room.password = "1234a"
        @room.password_confirmation = "1234a"
        @room.valid?
        expect(@room.errors.full_messages).to include("Password is invalid")
      end

      it 'passwordが6文字以上だが英字のみであると登録できない' do
        @room.password = "abcdef"
        @room.password_confirmation = "abcdef"
        @room.valid?
        expect(@room.errors.full_messages).to include("Password is invalid")
      end

      it 'passwordが6文字以上だが数字のみだと登録できない' do
        @room.password = "123456"
        @room.password_confirmation = "123456"
        @room.valid?
        expect(@room.errors.full_messages).to include("Password is invalid")
      end

      it 'password_confirmationが空だと登録できない' do
        @room.password_confirmation = ""
        @room.valid?
        expect(@room.errors.full_messages).to include("Password confirmation doesn't match Password")
      end

      it 'passwordとpassword_confirmationが異なっていると登録できない' do
        @room.password = "11111a"
        @room.password_confirmation = "1111111a"
        @room.valid?
        expect(@room.errors.full_messages).to include("Password confirmation doesn't match Password")
      end
    end
  end
end
