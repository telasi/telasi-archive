class AddBookPresenter < ActiveRecord::Migration
  def self.up
    add_column :books, :book_presenter, :string
  end

  def self.down
    remove_column :books, :book_presenter
  end
end
