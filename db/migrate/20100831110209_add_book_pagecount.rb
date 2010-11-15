class AddBookPagecount < ActiveRecord::Migration
  def self.up
    add_column :books, :page_count, :integer
    Book.find(:all).each {|book| book.page_count = 0; book.save;}
  end

  def self.down
    remove_column :books, :page_count
  end
end
