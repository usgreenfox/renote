require 'rails_helper'

describe 'モデルに関するテスト' do
  describe '実際に保存してみる' do
    it "有効な投稿内容の場合は保存されるか" do
      expect(FactoryBot.build(:comment)).to be_valid
    end
  end
  context '空白のバリデーションチェック' do
    it 'bodyが空白の場合にバリデーションチェックされ、空白のエラーメッセージが返ってきているか' do
      comment = Comment.new(body: '')
      expect(comment).to be_invalid
      expect(comment.errors[:body]).to include("を入力してください")
    end
  end
end