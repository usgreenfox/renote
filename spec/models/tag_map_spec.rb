require 'rails_helper'

describe 'モデルに関するテスト' do
  describe '実際に保存してみる' do
    it "有効な投稿内容の場合は保存されるか" do
      expect(FactoryBot.build(:tag_map)).to be_valid
    end
  end
  context '空白のチェック' do
    let(:user) { create(:user) }
    let(:note) { create(:note, user: user) }
    let(:tag) { create(:tag) }
    it 'note_idが空の時、保存されない' do
      tag_map = tag.tag_maps.new(note_id: '')
      expect(tag_map).to be_invalid
    end
    it 'tag_idが空の時、保存されない' do
      tag_map = note.tag_maps.new(tag_id: '')
      expect(tag_map).to be_invalid
    end
  end
end
