Task.destroy_all
User.destroy_all

admin = User.create!(
  name: 'admin',
  email: 'admin@example.com',
  password: 'password',
  admin: true
)

user = User.create!(
  name: 'user',
  email: 'user@example.com',
  password: 'password',
  admin: false
)

25.times do |i|
  Task.create!(
    title: "admin_task_#{i + 1}",
    content: "Content #{i + 1}",
    deadline_on: Date.today - i.days,
    priority: [:low, :medium, :high][i % 3],
    status: [:not_started, :in_progress, :completed][i % 3],
    user: admin
  )
end

25.times do |i|
  Task.create!(
    title: "user_task_#{i + 1}",
    content: "Content #{i + 1}",
    deadline_on: Date.today - i.days,
    priority: [:low, :medium, :high][i % 3],
    status: [:not_started, :in_progress, :completed][i % 3],
    user: user
  )
end