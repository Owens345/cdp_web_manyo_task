class Task < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :content, presence: true
  validates :deadline_on, presence: true
  validates :priority, presence: true
  validates :status, presence: true

  enum priority: { low: 0, medium: 1, high: 2 }
  enum status: { not_started: 0, in_progress: 1, completed: 2 }

  scope :latest, -> { order(created_at: :desc) }
  scope :sort_deadline, -> { order(deadline_on: :asc, created_at: :desc) }
  scope :sort_priority, -> { order(priority: :desc, created_at: :desc) }
  scope :search_title, ->(title) { where('title LIKE ?', "%#{title}%") }
  scope :search_status, ->(status) { where(status: status) }
  scope :search_title_and_status, ->(title, status) { where('title LIKE ?', "%#{title}%").where(status: status) }
end
