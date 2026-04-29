require 'rails_helper'

RSpec.describe 'Task management function', type: :system do

  describe 'Registration function' do
    context 'When registering a task' do
      it 'The registered task is displayed' do
        visit new_task_path
        fill_in 'タイトル', with: 'Document preparation'
        fill_in '内容', with: 'Create a proposal.'
        find('input[name="task[deadline_on]"]').set(Date.today)
        select '中', from: 'task[priority]'
        select '未着手', from: 'task[status]'
        click_button '登録する'
        expect(page).to have_content 'Document preparation'
      end
    end
  end

  describe 'List display function' do
    let!(:first_task)  { FactoryBot.create(:task, title: 'first_task',  deadline_on: '2022-02-18', priority: :medium, status: :not_started, created_at: '2022-02-18') }
    let!(:second_task) { FactoryBot.create(:second_task, title: 'second_task', deadline_on: '2022-02-17', priority: :high, status: :in_progress, created_at: '2022-02-17') }
    let!(:third_task)  { FactoryBot.create(:third_task, title: 'third_task',  deadline_on: '2022-02-16', priority: :low,  status: :completed,   created_at: '2022-02-16') }

    before do
      visit tasks_path
    end

    context 'When transitioning to the list screen' do
      it 'The list of created tasks is displayed in descending order of creation date and time.' do
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content 'first_task'
        expect(task_list[1]).to have_content 'second_task'
        expect(task_list[2]).to have_content 'third_task'
      end
    end

    context 'When creating a new task' do
      it 'New task is displayed at the top' do
        new_task = FactoryBot.create(:task, title: 'newest_task', created_at: Time.now)
        visit tasks_path
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content 'newest_task'
      end
    end

    describe 'Sort function' do
      context 'If you click on the link End Deadline' do
        it 'A list of tasks sorted in ascending order of due date is displayed.' do
          click_link '終了期限'
          sleep 0.2
          task_list = all('tbody tr')
          expect(task_list[0]).to have_content 'third_task'
          expect(task_list[1]).to have_content 'second_task'
          expect(task_list[2]).to have_content 'first_task'
        end
      end

      context 'If you click on the link Priority' do
        it 'A list of tasks sorted by priority is displayed' do
          click_link '優先度'
          sleep 0.2
          task_list = all('tbody tr')
          expect(task_list[0]).to have_content 'second_task'
          expect(task_list[1]).to have_content 'first_task'
          expect(task_list[2]).to have_content 'third_task'
        end
      end
    end

    describe 'Search function' do
      context 'If you do a fuzzy search by Title' do
        it 'Only tasks containing the search word will be displayed.' do
          fill_in 'タイトル', with: 'first'
          find('#search_task').click
          expect(page).to have_content 'first_task'
          expect(page).not_to have_content 'second_task'
          expect(page).not_to have_content 'third_task'
        end
      end

      context 'Search by status' do
        it 'Only tasks matching the searched status will be displayed' do
          select '未着手', from: 'search[status]'
          find('#search_task').click
          expect(page).to have_content 'first_task'
          expect(page).not_to have_content 'second_task'
          expect(page).not_to have_content 'third_task'
        end
      end

      context 'Title and search by status' do
        it 'Only tasks that contain the search word Title and match the status will be displayed' do
          fill_in 'タイトル', with: 'second'
          select '着手中', from: 'search[status]'
          find('#search_task').click
          expect(page).to have_content 'second_task'
          expect(page).not_to have_content 'first_task'
          expect(page).not_to have_content 'third_task'
        end
      end
    end
  end

  describe 'Detailed display function' do
    context 'When transitioned to any task details screen' do
      it 'The content of the task is displayed' do
        task = FactoryBot.create(:task)
        visit task_path(task)
        expect(page).to have_content 'Document preparation'
        expect(page).to have_content 'Create a proposal.'
      end
    end
  end

end