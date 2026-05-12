# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Task.destroy_all

50.times do |i|
  Task.create!(
    title: "task_#{i + 1}",
    content: "Content #{i + 1}",
    deadline_on: Date.today - i.days,
    priority: [:low, :medium, :high][i % 3],
    status: [:not_started, :in_progress, :completed][i % 3]
  )
end