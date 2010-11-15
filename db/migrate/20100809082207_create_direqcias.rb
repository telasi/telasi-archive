class CreateDireqcias < ActiveRecord::Migration
  def self.up
    create_table :direqcias do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
    add_index :direqcias, :code 
  end

  def self.down
    drop_table :direqcias
  end
end
