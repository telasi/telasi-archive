# ძებნის კლასი
class Search
  # ძებნის ატრიბუტები
  attr_accessor :name, :direqcia_id, :nomenclature_id

  # ძებნის ობიექტის შექმნა პარამეტრების რუკიდან
  def self.create(map)
    s = Search.new
    s.name = map[:name]
    s.direqcia_id = map[:direqcia_id] ? map[:direqcia_id].to_i : 0
    s.nomenclature_id = map[:nomenclature_id] ? map[:nomenclature_id].to_i : 0
    s
  end

  # ცარიელია თუ არა ეს ძებნა?
  def empty?
    if (name.nil? or name.empty?) and (direqcia_id  == 0) and (nomenclature_id == 0)
      return false
    else
      return true
    end
  end
end

# ძებნის კონტროლერი
class SearchController < ApplicationController

  def index
    @title = 'წიგნების ძებნა'
    
    if params[:search]
      @search = Search.create(params[:search])
      unless @search.empty?
        flash.now[:notice] = 'განსაზღვრეთ ძებნის პარამეტრები'
        @books = []
      else
        where = ''
        where_params = {}
        # სახელის დამატება
        unless @search.name.nil? or @search.name.empty?
          where += 'books.name like :name'
          where_params[:name] = '%' + @search.name + "%"
        end
        # დირექციის დამატება
        unless @search.direqcia_id == 0
          unless where.empty?
            where += ' and '
          end
          where += 'nomenclatures.direqcia_id = :direqcia_id'
          where_params[:direqcia_id] = @search.direqcia_id
        end
        # ნომენკლატურის დამატება
        unless @search.nomenclature_id == 0
          unless where.empty?
            where += ' and '
          end
          where += 'nomenclature_id = :nomenclature_id'
          where_params[:nomenclature_id] = @search.nomenclature_id
        end
        # წიგნების მიღება
        #@books = Book.all(:conditions => [where, where_params], :include => :nomenclature)
        @books = Book.paginate :page => params[:page], :conditions => [where, where_params], :include => :nomenclature, :order => 'books.name'
      end
    end
  end

end
