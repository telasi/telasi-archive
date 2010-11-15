class CreateBooks < ActiveRecord::Migration
  def self.up
    create_table :books do |t|
      t.string :name
      t.integer :order_by
      t.references :nomenclature
      t.references :place
      t.date :start_date
      t.date :end_date
      t.date :registration_date
      t.date :discard_date

      t.timestamps
    end
    add_index :books, [:place_id, :order_by]
    add_index :books, :nomenclature_id
  end

  def self.down
    drop_table :books
  end
end
