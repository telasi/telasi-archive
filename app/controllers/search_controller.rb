class Search
  attr_accessor :name, :direqcia_id, :nomenclature_id, :book_year, :enter_year

  def self.create(map)
    s = Search.new
    s.name = map[:name]
    s.direqcia_id = map[:direqcia_id] ? map[:direqcia_id].to_i : 0
    s.nomenclature_id = map[:nomenclature_id] ? map[:nomenclature_id].to_i : 0
    s.book_year = map[:book_year] ? map[:book_year] : nil
    s.enter_year = map[:enter_year] ? map[:enter_year] : nil
    s
  end

  def empty?
    (self.name.nil? or self.name.empty?) and (self.direqcia_id == 0) and (self.nomenclature_id == 0) and
    (self.book_year.nil? or self.book_year.empty?) and (self.enter_year.nil? or self.enter_year.empty?)
  end
end

class SearchController < ApplicationController

  def index
    @title = 'წიგნების ძებნა'
    if params[:search]
      @search = Search.create(params[:search] ? params[:search] : {})
      if @search.empty?
        flash.now[:notice] = 'განსაზღვრეთ ძებნის პარამეტრები'
        @books = []
      else
        where = ''
        where_params = {}
        # name
        unless @search.name.nil? or @search.name.empty?
          where += 'books.name like :name'
          where_params[:name] = '%' + @search.name + "%"
        end
        # direqcia
        unless @search.direqcia_id == 0
          unless where.empty?
            where += ' and '
          end
          where += 'nomenclatures.direqcia_id = :direqcia_id'
          where_params[:direqcia_id] = @search.direqcia_id
        end
        # nomenclature
        unless @search.nomenclature_id == 0
          unless where.empty?
            where += ' and '
          end
          where += 'nomenclature_id = :nomenclature_id'
          where_params[:nomenclature_id] = @search.nomenclature_id
        end
        # book_year
        unless @search.book_year.nil? or @search.book_year.empty?
          unless where.empty?
            where += ' and '
          end
          where += 'book_year = :book_year'
          where_params[:book_year] = @search.book_year
        end
        # enter_year
        unless @search.enter_year.nil? or @search.enter_year.empty?
          unless where.empty?
            where += ' and '
          end
          where += 'enter_year = :enter_year'
          where_params[:enter_year] = @search.enter_year
        end
        # get books
        #@books = Book.all(:conditions => [where, where_params], :include => :nomenclature)
        @books = Book.paginate :page => params[:page], :conditions => [where, where_params], :include => :nomenclature, :order => 'books.name'
      end
    end
  end

end