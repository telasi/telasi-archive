class CreateTaskBodies < ActiveRecord::Migration
  def self.up
    create_table :task_bodies do |t|
      t.references :task
      t.references :from
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :task_bodies
  end
end
