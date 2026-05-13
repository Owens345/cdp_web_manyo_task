class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }, allow_blank: false, on: :create
  validates :password, length: { minimum: 6 }, allow_nil: true, on: :update
  before_save :downcase_email
  before_destroy :check_admin_count
  before_update :check_admin_update

  private

  def downcase_email
    self.email = email.downcase
  end

  def check_admin_count
    if admin? && User.where(admin: true).count == 1
      errors.add(:base, '管理者が0人になるため削除できません')
      throw :abort
    end
  end

  def check_admin_update
    if admin_changed? && !admin && User.where(admin: true).count == 1
      errors.add(:base, '管理者が0人になるため権限を変更できません')
      throw :abort
    end
  end
end