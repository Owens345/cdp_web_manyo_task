class AddUserIdToTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :user_id, :bigint
    add_index :tasks, :user_id
    add_foreign_key :tasks, :users
  end
end
