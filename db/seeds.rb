Task.delete_all
User.delete_all

admin = User.find_or_create_by!(email: 'admin@example.com') do |u|
  u.name = 'admin'
  u.password = 'password'
  u.admin = true
end

user = User.find_or_create_by!(email: 'user@example.com') do |u|
  u.name = 'user'
  u.password = 'password'
  u.admin = false
end

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