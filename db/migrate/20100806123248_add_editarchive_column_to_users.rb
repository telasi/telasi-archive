class AddEditarchiveColumnToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :editarchive, :boolean, {:default => 0}
  end

  def self.down
    remove_column :users, :editarchive
  end
end
