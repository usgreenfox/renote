require 'rails_helper'

describe 'モデルに関するテスト' do
  describe '実際に保存してみる' do
    it "有効な投稿内容の場合は保存されるか" do
      expect(FactoryBot.build(:note)).to be_valid
    end
  end
  context '空白のバリデーションチェック' do
    it 'titleが空白の場合にバリデーションチェックされ、空白のエラーメッセージが返ってきているか' do
      note = Note.new(title: '', body: Faker::Lorem.characters(number:300) )
      expect(note).to be_invalid
      expect(note.errors[:title]).to include("を入力してください")
    end
    it 'bodyが空白の場合にバリデーションチェックされ、空白のエラーメッセージが返ってきているか' do
      note = Note.new(title: Faker::Lorem.characters(number:30), body: '')
      expect(note).to be_invalid
      expect(note.errors[:body]).to include("を入力してください")
    end
  end
end