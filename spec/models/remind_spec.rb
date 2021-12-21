require 'rails_helper'

describe 'モデルに関するテスト' do
  describe '実際に保存してみる' do
    it "有効な投稿内容の場合は保存されるか" do
      expect(FactoryBot.build(:remind)).to be_valid
    end
  end
  context '空白のチェック' do
    let(:user) { create(:user) }
    let(:note) { create(:note, user: user) }
    it 'note_idが空の時、保存されない' do
      remind = user.reminds.new(note_id: '')
      expect(remind).to be_invalid
    end
    it 'user_idが空の時、保存されない' do
      remind = note.reminds.new(user_id: '')
      expect(remind).to be_invalid
    end
  end
end