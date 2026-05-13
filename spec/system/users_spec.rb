require 'rails_helper'

RSpec.describe 'User management function', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:admin) { FactoryBot.create(:admin_user) }

  describe 'Registration function' do
    context 'When a user is registered' do
      it 'Transition to the task list screen' do
        visit new_user_path
        sleep 0.5
        find('#user_name').set('new_user')
        find('#user_email').set('new_user@example.com')
        find('#user_password').set('password')
        find('#user_password_confirmation').set('password')
        click_button '登録する'
        sleep 0.5
        expect(page).to have_content 'タスク一覧ページ'
      end
    end

    context 'When you move to the Task List screen without logging in' do
      it 'The user is redirected to the login screen and the message "Please log in" is displayed.' do
        visit tasks_path
        sleep 0.5
        expect(current_path).to eq new_session_path
        expect(page).to have_content 'ログインしてください'
      end
    end
  end

  describe 'Login function' do
    context 'When logged in as a registered user' do
      before do
        visit new_session_path
        sleep 0.5
        find('input[name="session[email]"]').set(user.email)
        find('input[name="session[password]"]').set('password')
        click_button 'ログイン'
        sleep 0.5
      end

      it 'Moves to the Task List screen and displays the message "You are logged in."' do
        expect(page).to have_content 'タスク一覧ページ'
        expect(page).to have_content 'ログインしました'
      end

      it 'Access to your own detail screen.' do
        visit user_path(user)
        sleep 0.5
        expect(page).to have_content 'アカウント詳細ページ'
      end

      it "Accessing someone else's detail screen will take you to the task list screen." do
        visit user_path(admin)
        sleep 0.5
        expect(current_path).to eq tasks_path
        expect(page).to have_content 'アクセス権限がありません'
      end

      it 'When logging out, the user is taken to the login screen and the message "You have logged out" is displayed.' do
        click_link 'ログアウト'
        sleep 0.5
        expect(current_path).to eq new_session_path
        expect(page).to have_content 'ログアウトしました'
      end
    end
  end

  describe 'Administrator function' do
    context 'When the administrator logs in' do
      before do
        visit new_session_path
        sleep 0.5
        find('input[name="session[email]"]').set(admin.email)
        find('input[name="session[password]"]').set('password')
        click_button 'ログイン'
        sleep 0.5
      end

      it 'Access to the user list screen' do
        visit admin_users_path
        sleep 0.5
        expect(page).to have_content 'ユーザ一覧ページ'
      end

      it 'Can register administrators' do
        visit new_admin_user_path
        sleep 0.5
        find('#user_name').set('new_admin')
        find('#user_email').set('new_admin@example.com')
        find('#user_password').set('password')
        find('#user_password_confirmation').set('password')
        check 'user[admin]'
        click_button '登録する'
        sleep 0.5
        expect(page).to have_content 'ユーザ一覧ページ'
        expect(User.find_by(email: 'new_admin@example.com').admin).to eq true
      end

      it 'Access to user details screen' do
        visit admin_user_path(user)
        sleep 0.5
        expect(page).to have_content 'ユーザ詳細ページ'
      end

      it 'Edit users other than yourself from the user edit screen' do
        visit edit_admin_user_path(user)
        sleep 0.5
        find('#user_name').set('updated_user')
        find('#user_email').set('updated_user@example.com')
        find('#user_password').set('password')
        find('#user_password_confirmation').set('password')
        click_button '更新する'
        sleep 0.5
        expect(page).to have_content 'ユーザ一覧ページ'
      end

      it 'Users can be deleted.' do
        visit admin_users_path
        sleep 0.5
        click_link '削除', href: admin_user_path(user)
        sleep 0.5
        page.driver.browser.switch_to.alert.accept
        sleep 0.5
        expect(page).to have_content 'ユーザ一覧ページ'
      end
    end

    context 'When a general user accesses the User List screen' do
      before do
        visit new_session_path
        sleep 0.5
        find('input[name="session[email]"]').set(user.email)
        find('input[name="session[password]"]').set('password')
        click_button 'ログイン'
        sleep 0.5
      end

      it 'Moves to the task list screen and displays the error message "Only administrators can access this screen".' do
        visit admin_users_path
        sleep 0.5
        expect(current_path).to eq tasks_path
        expect(page).to have_content '管理者以外アクセスできません'
      end
    end
  end
end
