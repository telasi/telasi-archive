# encoding: utf-8
class Search
  attr_accessor :name, :direqcia_id, :nomenclature_id, :book_year, :enter_year, :book_presenter

  def self.create(map)
    s = Search.new
    s.name = map[:name]
    s.direqcia_id = map[:direqcia_id] ? map[:direqcia_id].to_i : 0
    s.nomenclature_id = map[:nomenclature_id] ? map[:nomenclature_id].to_i : 0
    s.book_year = map[:book_year] ? map[:book_year] : nil
    s.enter_year = map[:enter_year] ? map[:enter_year] : nil
    s.book_presenter = map[:book_presenter] ? map[:book_presenter] : nil
    s
  end

  def empty?
    (self.name.nil? or self.name.empty?) and (self.direqcia_id == 0) and (self.nomenclature_id == 0) and
    (self.book_year.nil? or self.book_year.empty?) and (self.enter_year.nil? or self.enter_year.empty?) and
    (self.book_presenter.nil? or self.book_presenter.empty?)
  end
end

class SearchController < ApplicationController

  def index
    @title = 'წიგნების ძებნა'

    if params[:search]
      @search = Search.create(params[:search] ? params[:search] : {})
      @books = find_books(@search)
    else
      @books = []
    end

    @links = []
    @parent = find_parent
    if @parent
      parent = @parent
      while parent
        params[:parent_id] = parent.id
        @links.push({ :url => url_for(search_url(params)), :name => parent.name })
        parent = parent.parent
      end
    end
    params[:parent_id] = 0
    @links.push({ :url => url_for(search_url(params)), :name => 'საწყისი' })
    @links = @links.reverse
    @places = PlacesController.find_places(session[:search_parent_id])
  end

  def search_move
    if check_edit
      book = Book.find(params[:move_id])
      parent = find_parent
      book.place = parent
      book.save
      redirect_to search_url(:search => params[:search])
    end
  end

  def find_parent
    if params[:parent_id]
      if params[:parent_id] == '0'
        session[:search_parent_id] = nil
      else
        session[:search_parent_id] = params[:parent_id]
      end
    end
    if session[:search_parent_id]
      Place.find(session[:search_parent_id].to_i)
    else
      nil
    end
  end

  def name_condition(text)
    names = text.split
    nameparams = []
    cond = '('
    index = 0
    names.each do |name|
      if (index > 0)
        cond += ' and '
      end
      cond += "books.name like ?"
      nameparams.push "%#{name}%"
      index += 1
    end
    cond += ')'
    [cond, nameparams]
  end

  def find_books(search)
    if search.empty?
      flash.now[:notice] = 'განსაზღვრეთ ძებნის პარამეტრები'
      books = []
    else
      where = ''
      where_params = []
      # name
      unless search.name.nil? or search.name.empty?
        cond, nameparams = name_condition(search.name)
        where += cond
        where_params = nameparams
      end
      # direqcia
      unless search.direqcia_id == 0
        unless where.empty?
          where += ' and '
        end
        where += 'nomenclatures.direqcia_id = ?'
        where_params.push(search.direqcia_id)
      end
      # nomenclature
      unless search.nomenclature_id == 0
        unless where.empty?
          where += ' and '
        end
        where += 'nomenclature_id = ?'
        where_params.push(search.nomenclature_id)
      end
      # book_year
      unless search.book_year.nil? or search.book_year.empty?
        unless where.empty?
          where += ' and '
        end
        where += 'book_year = ?'
        where_params.push(search.book_year)
      end
      # enter_year
      unless search.enter_year.nil? or search.enter_year.empty?
        unless where.empty?
          where += ' and '
        end
        where += 'enter_year = ?'
        where_params.push(search.enter_year)
      end
      # book_presenter
      unless search.book_presenter.nil? or search.book_presenter.empty?
        unless where.empty?
          where += ' and '
        end
        where += 'book_presenter LIKE ?'
        where_params.push("%#{search.book_presenter}%")
      end
      # get books
      #@books = Book.all(:conditions => [where, where_params], :include => :nomenclature)
      conditions = [where]
      conditions += where_params
      books = Book.paginate :page => params[:page], :conditions => conditions, :include => :nomenclature, :order => 'books.name'
    end
    books
  end

end