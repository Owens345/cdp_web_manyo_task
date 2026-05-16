FactoryBot.define do
  factory :task do
    title { 'Document preparation' }
    content { 'Create a proposal.' }
    deadline_on { Date.today }
    priority { :medium }
    status { :not_started }
    association :user
  end

  factory :second_task, class: Task do
    title { 'second_task' }
    content { 'Content 2' }
    deadline_on { '2022-02-17' }
    priority { :high }
    status { :in_progress }
    association :user
  end

  factory :third_task, class: Task do
    title { 'third_task' }
    content { 'Content 3' }
    deadline_on { '2022-02-16' }
    priority { :low }
    status { :completed }
    association :user
  end
end
