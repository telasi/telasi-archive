class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.string :subject
      t.text :last_body
      t.string :status
      t.references :from

      t.timestamps
    end
    add_index :tasks, :from_id
  end

  def self.down
    drop_table :tasks
  end
end
