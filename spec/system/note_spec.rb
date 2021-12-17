# frozen_string_literal: true

require 'rails_helper'

describe '投稿のテスト' do
  let!(:note) { create(:note, title: 'hoge', body: 'fuga') }
  describe 'トップ画面(homes_top_path)のテスト' do
    before do
      visit homes_top_path
    end
    context '表示の確認' do
      it 'top_home_pathが"/"であるか' do
        expect(current_path).to eq('/homes/top')
      end
      it 'トップ画面に"About"が表示されているか' do
        expect(page).to have_content'About'
      end
      it 'トップ画面に"Note"が表示されているか' do
        expect(page).to have_content'Note'
      end
      it 'トップ画面に"Contact us"が表示されているか' do
        expect(page).to have_content'Contact us'
      end
    end
  end

  describe "投稿画面(new_note_path)のテスト" do
    let!(:user) { create(:user, name: 'test', email: 'test@gmail.com', password: 'password') }
    before do
      sign_in user
      visit new_note_path
    end
    context '表示の確認' do
      it 'new_note_pathが"/notes/new"であるか' do
        expect(current_path).to eq('/notes/new')
      end
      it '投稿ボタンが表示されているか' do
        expect(page).to have_button '登録する'
      end
    end
    context '投稿処理のテスト' do
      it '投稿後のリダイレクト先は正しいか' do
        fill_in 'note[title]', with: Faker::Lorem.characters(number:5)
        # fill_in_rich_text_area 'note[body]', with: Faker::Lorem.characters(number:20)
        click_button '登録する'
        expect(page).to have_current_path note_path(Last.note)
      end
    end
  end
end