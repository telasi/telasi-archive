class CreatePlaces < ActiveRecord::Migration
  def self.up
    create_table :places do |t|
      t.string :name
      t.references :parent

      t.timestamps
    end
    add_index :places, :name
    add_index :places, :parent_id
  end

  def self.down
    drop_table :places
  end
end
