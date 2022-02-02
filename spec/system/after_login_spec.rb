# frozen_string_literal: true

require 'rails_helper'

describe 'ユーザーログイン後のテスト' do
  let!(:user) { create(:user) }
  let!(:note) { create(:note, user: user) }
  let!(:comment) { create(:comment, user: user, note: user.notes.first) }
  before { sign_in user }

  describe 'トップ画面のテスト' do
    before { visit root_path }
    it { expect(current_path).to eq '/' }
    context '表示の確認' do
      subject { page }
      it { is_expected.to have_link 'Re:note', href: root_path }
      it { is_expected.to have_link 'Mypage', href: user_path(user) }
      it { is_expected.to have_link 'Log out', href: destroy_user_session_path }
      it { is_expected.to have_content'About' }
      it { is_expected.to have_content'Recommends' }
      it { is_expected.to have_content'Contact us' }
    end
    context '遷移の確認' do
      subject { current_path }
      it 'Re:noteを押すと、トップ画面に遷移する' do
        click_link 'Re:note'
        is_expected.to eq '/'
      end
      it 'Mypageを押すと、マイページ画面に遷移する' do
        click_link 'Mypage'
        is_expected.to eq "/users/#{user.id}"
      end
      it 'Log outを押すと、トップ画面に遷移する' do
        click_link 'Log out'
        is_expected.to eq '/'
      end
      it 'Aboutを押すと、アバウト画面に遷移する' do
        click_link 'About'
        is_expected.to eq '/homes/about'
      end
      it 'Recommendsを押すと、recommend一覧画面に遷移する' do
        click_link 'Recommends'
        is_expected.to eq '/recommends'
      end
    end
  end

  describe "投稿画面のテスト" do
    before { visit new_note_path }
    it { expect(current_path).to eq '/notes/new' }
    context '投稿処理のテスト' do
      it '投稿後のリダイレクト先は正しいか' do
        fill_in 'note[title]', with: Faker::Lorem.characters(number:5)
        # Trixエディターを使用しているため、find(:xpath).setを使用している
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

  describe 'ノート編集画面のテスト' do
    before { visit edit_note_path(note) }
    it { expect(current_path).to eq "/notes/#{note.id}/edit" }
    context 'フォームの確認' do
      subject { page }
      it { is_expected.to have_field('note[title]', with: note.title) }
      # WANT: フォーム（Trix）にbodyが入っているか確認
      # WANT: フォームにタグが入っているか確認
      context '更新処理の成功' do
        it 'titleの更新' do
          update_title = Faker::Lorem.characters(number:5)
          fill_in 'note[title]', with: update_title
          click_button '更新する'
          is_expected.to have_current_path note_path(note)
          is_expected.to have_content update_title
        end
        it 'bodyの更新' do
          update_body = Faker::Lorem.characters(number:10)
          find(:xpath, "//*[@id='note_body']", visible: false).set update_body
          click_button '更新する'
          is_expected.to have_current_path note_path(note)
          is_expected.to have_content update_body
        end
        it 'tagの更新' do
          update_tag = Faker::Lorem.characters(number:10)
          fill_in 'note[tag_name]', with: update_tag
          click_button '更新する'
          is_expected.to have_current_path note_path(note)
          is_expected.to have_content update_tag
        end
      end
      context '更新処理の失敗' do
        it 'tilteの更新' do
          update_title = ''
          fill_in 'note[title]', with: update_title
          click_button '更新する'
          is_expected.to have_current_path edit_note_path(note)
        end
        it 'bodyの更新' do
          update_body = ''
          find(:xpath, "//*[@id='note_body']", visible: false).set update_body
          click_button '更新する'
          is_expected.to have_current_path edit_note_path(note)
        end
      end
    end
  end

  describe '詳細画面のテスト' do
    let!(:comment) { create(:comment, note: note, user: user) }
    before { visit note_path(note) }
    it { expect(current_path).to eq "/notes/#{note.id}" }
    context '表示の確認' do
      subject { page }
      it { is_expected.to have_link '', href: user_path(note.user) }
      it { is_expected.to have_link '', href: edit_note_path(note) }
      it { is_expected.to have_no_css '.fa-bookmark' }
      it { is_expected.to have_css '.fa-clock' }
      it { is_expected.to have_content note.title }
      it { is_expected.to have_content note.tags.first.name }
      it { is_expected.to have_content note.body }
      it { is_expected.to have_content comment.body }
      it { is_expected.to have_content 'Delete' }
      it { is_expected.to have_css '.comment-form' }
    end
    # Capybara + cloud9 ではform_withがlocal: trueで送信されてしまうため、
    # Ajaxを使用しているコメント投稿のテストができない。
    # 設定を変えることはできるが、今の技術レベルでは難しいと判断。
  end

  describe 'ユーザー詳細画面のテスト' do
    before { visit user_path(user) }
    it { expect(current_path).to eq "/users/#{user.id}" }
    context '表示の確認' do
      subject { page }
      it { is_expected.to have_content user.email }
      it { is_expected.to have_content user.name }
    end
    context 'リンクの確認' do
      it '編集をクリックすると編集ページに遷移する' do
        click_link '編集'
        expect(current_path).to eq "/users/#{user.id}/edit"
      end
    end
  end

  describe 'ユーザー編集画面のテスト' do
    before { visit edit_user_path(user) }
    it { expect(current_path).to eq "/users/#{user.id}/edit" }
    context 'フォームの確認' do
      subject { page }
      it { is_expected.to have_field('user[name]', with: user.name) }
      it { is_expected.to have_field('user[email]', with: user.email) }
      context '更新処理の成功' do
        it 'nameを入力して保存' do
          fill_in 'user[name]', with: 'test'
          click_button '更新'
          expect(current_path).to eq "/users/#{user.id}"
          is_expected.to have_content 'test'
        end
        it 'emailを入力して保存' do
          fill_in 'user[email]', with: 'test@gmail.com'
          click_button '更新'
          expect(current_path).to eq "/users/#{user.id}"
          is_expected.to have_content 'test@gmail.com'
        end
      end
      context '更新処理の失敗' do
        it 'nameが空白' do
          fill_in 'user[name]', with: ''
          click_button '更新'
          expect(current_path).to eq "/users/#{user.id}/edit"
          is_expected.to have_content '名前を入力してください'
        end
        it 'emailが空白' do
          fill_in 'user[email]', with: ''
          click_button '更新'
          expect(current_path).to eq "/users/#{user.id}/edit"
          is_expected.to have_content 'メールアドレスを入力してください'
        end
      end
    end
  end
end
