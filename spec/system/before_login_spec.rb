require 'rails_helper'

describe 'ユーザーログイン前のテスト' do
  let!(:user) { create(:user) }
  let!(:note) { create(:note, user: user) }
  let!(:comment) { create(:comment, user: user, note: user.notes.first) }

  describe 'トップ画面(homes_top_path)のテスト' do
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
        it 'Sign upリンクが表示される' do
          sign_up_link = find_all('a')[1].native.inner_text
          expect(sign_up_link).to match('Sign up')
        end
        it 'Sign inリンクが表示される' do
          sign_in_link = find_all('a')[2].native.inner_text
          expect(sign_in_link).to match('Sign in')
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
      it 'Sign upを押すと、新規登録画面に遷移する' do
        click_link 'Sign up'
        expect(current_path).to eq '/users/sign_up'
      end
      it 'Sign inを押すと、ログイン画面に遷移する' do
        click_link 'Sign in'
        expect(current_path).to eq '/users/sign_in'
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

  describe 'アバウト画面のテスト' do
    before do
      visit '/homes/about'
    end
    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/homes/about'
      end
    end
  end

  describe 'ノートの閲覧のテスト' do
    context 'ノート一覧画面のテスト' do
      before do
        visit notes_path
      end
      it 'URLが正しい' do
        expect(current_path).to eq '/notes'
      end
      it 'ノートが表示されているか' do
        expect(page).to have_content note.title
      end
      it 'タイトルを押すと、ノート詳細ページに遷移する' do
        click_on note.title
        expect(current_path).to eq "/notes/#{note.id}"
      end
      it '投稿者名が表示されているか' do
        expect(page).to have_content user.name
      end
      it '投稿者名を押すと、ユーザー詳細ページに遷移する' do
        click_on user.name
        expect(current_path).to eq "/users/#{user.id}"
      end
    end
    context 'ノート詳細画面のテスト' do
      before do
        visit note_path(note)
      end
      it 'URLが正しい' do
        expect(current_path).to eq "/notes/#{note.id}"
      end
      it '投稿者名が表示されているか' do
        expect(page).to have_content note.user.name
      end
      it '投稿者名を押すと、ユーザー詳細ページに遷移する' do
        click_on note.user.name, match: :first
        expect(current_path).to eq "/users/#{note.user.id}"
      end
      it '編集ボタンが表示されているか' do
        expect(page).to have_no_link '', href: edit_note_path(note)
      end
      it 'ブックマークボタンが表示されていない' do
        expect(page).to have_no_css '.fa-bookmark'
      end
      it 'リマインダーボタンが表示されていない' do
        expect(page).to have_no_css '.fa-clock'
      end
      context 'コメント表示のテスト' do
        it 'コメントが表示されている' do
          expect(page).to have_content comment.body
        end
        it 'Deleteボタンが表示されていない' do
          expect(page).to have_no_content 'Delete'
        end
        it 'フォームが表示されない' do
          expect(page).to have_no_css '.comment-form'
        end
      end
    end
  end

  describe 'ユーザー詳細画面のテスト' do
    before do
      visit user_path(user)
    end
    it 'URLが正しい' do
      expect(current_path).to eq "/users/#{user.id}"
    end
    it 'ユーザーのメールアドレスが表示されない' do
      expect(page).to have_no_content user.email
    end
  end
end