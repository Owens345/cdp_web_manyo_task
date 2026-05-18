require 'rails_helper'

RSpec.describe 'Label management function', type: :system do
  let!(:user) do
    User.create!(
      name: "test user",
      email: "test@example.com",
      password: "password",
      password_confirmation: "password"
    )
  end

  let!(:label) { FactoryBot.create(:label, user: user) }

  before do
    visit new_session_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
    sleep 0.5
  end

  describe 'Registration function' do
    context 'When a label is registered' do
      it 'Registered labels are displayed.' do
        visit new_label_path
        sleep 0.5
        find('input[name="label[name]"]').set('new_label')
        click_button '登録する'
        sleep 0.5
        expect(page).to have_content 'new_label'
      end
    end
  end

  describe 'List display function' do
    context 'When transitioning to the list screen' do
      it 'A list of registered labels is displayed.' do
        visit labels_path
        sleep 0.5
        expect(page).to have_content label.name
      end
    end
  end
end
