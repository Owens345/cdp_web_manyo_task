class CreateJoinTableTasksLabels < ActiveRecord::Migration[6.1]
  def change
    create_join_table :tasks, :labels do |t|
      t.index :task_id
      t.index :label_id
    end
  end
end