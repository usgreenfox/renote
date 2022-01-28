require 'rails_helper'

describe 'ユーザーログイン前のテスト' do
  let!(:user) { create(:user) }
  let!(:note) { create(:note, user: user) }
  let!(:comment) { create(:comment, user: user, note: user.notes.first) }

  describe 'トップ画面(homes_top_path)のテスト' do
    before { visit root_path }
    it { expect(current_path).to eq '/' }
    context '表示の確認' do
      subject { page }
      it { is_expected.to have_link 'Re:note', href: root_path }
      it { is_expected.to have_link 'Sign up', href: new_user_registration_path }
      it { is_expected.to have_link 'Sign in', href: new_user_session_path }
      it { is_expected.to have_link 'About', href: homes_about_path }
      it { is_expected.to have_link 'Note', href: notes_path }
      it { is_expected.to have_link 'Contact us', href: contacts_new_path }
    end
    context '遷移の確認' do
      subject { current_path }
      it 'Re:noteを押すと、トップ画面に遷移する' do
        click_link 'Re:note'
        is_expected.to eq '/'
      end
      it 'Sign upを押すと、新規登録画面に遷移する' do
        click_link 'Sign up'
        is_expected.to eq '/users/sign_up'
      end
      it 'Sign inを押すと、ログイン画面に遷移する' do
        click_link 'Sign in'
        is_expected.to eq '/users/sign_in'
      end
      it 'Aboutを押すと、アバウト画面に遷移する' do
        click_link 'About'
        is_expected.to eq '/homes/about'
      end
      it 'Noteを押すと、ノート一覧画面に遷移する' do
        click_link 'Note'
        is_expected.to eq '/notes'
      end
    end
  end

  describe 'アバウト画面のテスト' do
    before { visit '/homes/about' }
    it { expect(current_path).to eq '/homes/about' }
  end

  describe 'ノート一覧画面のテスト' do
    before { visit notes_path }
    it { expect(current_path).to eq '/notes' }
    context '表示の確認' do
      subject { page }
      it { is_expected.to have_link note.title, href: note_path(note) }
      it { is_expected.to have_link user.name, href: user_path(user) }
    end
    context '遷移の確認' do
      subject { current_path }
      it 'タイトルを押すと、ノート詳細ページに遷移する' do
        click_on note.title
        is_expected.to eq "/notes/#{note.id}"
      end
      it '投稿者名を押すと、ユーザー詳細ページに遷移する' do
        click_on user.name
        is_expected.to eq "/users/#{user.id}"
      end
    end
  end

  describe 'ノート詳細画面のテスト' do
    before { visit note_path(note) }
    it { expect(current_path).to eq "/notes/#{note.id}" }
    context '表示の確認' do
      subject { page }
      it { is_expected.to have_link note.user.name, href: user_path(user) }
      it { is_expected.to have_no_link '', href: edit_note_path(note) }
      it { is_expected.to have_no_css '.fa-bookmark' }
      it { is_expected.to have_no_css '.fa-clock' }
      it { is_expected.to have_content comment.body }
      it { is_expected.to have_no_content 'Delete' }
      it { is_expected.to have_no_css '.comment-form' }
    end

    context '遷移の確認' do
      subject { current_path }
      it '投稿者名を押すと、ユーザー詳細ページに遷移する' do
        click_on note.user.name, match: :first
        is_expected.to eq "/users/#{note.user.id}"
      end
      # WANT: タグ検索のページ遷移
    end
  end

  describe 'ユーザー詳細画面のテスト' do
    before { visit user_path(user) }
    it { expect(current_path).to eq "/users/#{user.id}" }
    context '表示の確認' do
      subject { page }
      it { is_expected.to have_no_content user.email }
      it { is_expected.to have_no_link '', href: edit_user_path(user) }
      it { is_expected.to have_no_link '', href: new_note_path  }
    end
  end
end