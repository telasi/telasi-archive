class AddBooksCustomOrder < ActiveRecord::Migration
  def self.up
    add_column :books, :custom_order, :integer
    add_index :books, [:place_id, :custom_order]
  end

  def self.down
    remove_column :books, :custom_order
  end
end
