class DeleteBookDates < ActiveRecord::Migration
  def self.up
    remove_column :books, :registration_date
    remove_column :books, :discard_date
  end

  def self.down
    add_column :books, :registration_date, :date
    add_column :books, :discard_date, :date
  end
end
