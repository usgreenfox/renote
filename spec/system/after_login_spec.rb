# frozen_string_literal: true

require 'rails_helper'

describe 'ユーザーログイン後のテスト' do
  let!(:user) { create(:user) }
  let!(:note) { create(:note, user: user) }
  let!(:comment) { create(:comment, user: user, note: user.notes.first) }

  before do
    sign_in user
  end

  describe 'トップ画面のテスト' do
    before do
      visit root_path
    end
    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/'
      end
      context 'Navの表示の確認' do
        it 'Re:noteリンクが表示される' do
          renote_link = find_all('a')[0].native.inner_text
          expect(renote_link).to match('Re:note')
        end
        it 'Mypageリンクが表示される' do
          mypage_link = find_all('a')[1].native.inner_text
          expect(mypage_link).to match('Mypage')
        end
        it 'Log outリンクが表示される' do
          log_out_link = find_all('a')[2].native.inner_text
          expect(log_out_link).to match('Log out')
        end
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
    context 'リンク先の確認' do
      it 'Re:noteを押すと、トップ画面に遷移する' do
        click_link 'Re:note'
        expect(current_path).to eq '/'
      end
      it 'Mypageを押すと、マイページ画面に遷移する' do
        click_link 'Mypage'
        expect(current_path).to eq "/users/#{user.id}"
      end
      it 'Log outを押すと、トップ画面に遷移する' do
        click_link 'Log out'
        expect(current_path).to eq '/'
      end
      it 'Aboutを押すと、アバウト画面に遷移する' do
        click_link 'About'
        expect(current_path).to eq '/homes/about'
      end
      it 'Noteを押すと、ノート一覧画面に遷移する' do
        click_link 'Note'
        expect(current_path).to eq '/notes'
      end
    end
  end

  describe "投稿画面(new_note_path)のテスト" do
    before do
      visit new_note_path
    end
    it 'URLが正しい' do
      expect(current_path).to eq '/notes/new'
    end
    context '投稿処理のテスト' do
      it '投稿後のリダイレクト先は正しいか' do
        fill_in 'note[title]', with: Faker::Lorem.characters(number:5)
        find(:xpath, "//*[@id='note_body']", visible: false).set 'my value'
        fill_in 'note[tag_name]', with: Faker::Lorem.characters(number:5)
        click_button '登録する'
        expect(page).to have_current_path note_path(Note.last)
      end
      it 'エラー時のリダイレクト先は正しいか' do
        click_button '登録する'
        expect(page).to have_current_path new_note_path
      end
    end
  end

  describe '詳細画面(note_path)のテスト' do
    let!(:comment) { create(:comment, note: note, user: user) }
    before do
      visit note_path(note)
    end
    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq "/notes/#{note.id}"
      end
      it '編集ボタンが表示されているか' do
        expect(page).to have_link '', href: edit_note_path(note)
      end
      it 'ブックマークボタンが表示されていない' do
        expect(page).to have_no_css '.fa-bookmark'
      end
      it 'リマインダーボタンが表示されているか' do
        expect(page).to have_css '.fa-clock'
      end
      it 'コメントが表示されている' do
        expect(page).to have_content comment.body
      end
      it 'Deleteボタンが表示されている' do
        expect(page).to have_content 'Delete'
      end
      it 'フォームが表示されている' do
        expect(page).to have_css '.comment-form'
      end
    end
  end

  describe 'ユーザー詳細画面のテスト' do
    before do
      visit user_path(user)
    end
    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq "/users/#{user.id}"
      end
      it 'emailが表示されている' do
        expect(page).to have_content user.email
      end
      it 'nameが表示されている' do
        expect(page).to have_content user.name
      end
    end
    context 'リンクの確認' do
      it '編集をクリックすると編集ページに遷移する' do
        click_link '編集'
        expect(current_path).to eq "/users/#{user.id}/edit"
      end
    end
  end

  describe 'ユーザー編集画面のテスト' do
    before do
      visit edit_user_path(user)
    end
    context 'フォームの確認' do
      it 'nameフォームに値が入っている' do
        expect(page).to have_field('user[name]', with: user.name)
      end
      it 'emailフォームに値が入っている' do
        expect(page).to have_field('user[email]', with: user.email)
      end
    end
    context '更新処理のテスト' do
      it 'nameを入力して保存' do
        fill_in 'user[name]', with: 'test'
        click_button '更新'
        expect(current_path).to eq "/users/#{user.id}"
        expect(page).to have_content 'test'
      end
      it 'emailを入力して保存' do
        fill_in 'user[email]', with: 'test@gmail.com'
        click_button '更新'
        expect(current_path).to eq "/users/#{user.id}"
        expect(page).to have_content 'test@gmail.com'
      end
    end
  end

end