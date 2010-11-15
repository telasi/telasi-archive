class AddBooksYearColumn < ActiveRecord::Migration
  def self.up
    add_column :books, :book_year, :integer
    add_column :books, :enter_year, :integer
    add_index :books, :book_year
    add_index :books, :enter_year
    Book.find(:all).each do |book|
      book.book_year = book.start_date.year
      book.enter_year = book.created_at.year
      book.save
    end
  end

  def self.down
    remove_column :books, :book_year
    remove_column :books, :enter_year
  end
end
