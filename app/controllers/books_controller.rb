class BooksController < ApplicationController
  before_filter :check_edit, :except => [:index, :show]

  # GET /books
  # GET /books.xml
  def index
    @title = 'წიგნების სია'
    @books = Book.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @books }
    end
  end

  # GET /books/1
  # GET /books/1.xml
  def show
    @book = Book.find(params[:id])
    @title = @book.name

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @book }
    end
  end

  # GET /books/new
  # GET /books/new.xml
  def new
    @book = Book.new
    @book.page_count = 0
    @title = 'ახალი წიგნი'
    @include_calendar = true
    
    if params[:copy_id]
      copy = Book.find(params[:copy_id])
      @book.name = copy.name
      @book.order_by = copy.order_by
      @book.nomenclature = copy.nomenclature
      @book.start_date = copy.start_date
      @book.end_date = copy.end_date
      @book.page_count = copy.page_count
    end
    
    session[:parent_id] = request[:parent_id]
    if session[:parent_id]
      @parent = Place.find(session[:parent_id])
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @book }
    end
  end

  # GET /books/1/edit
  def edit
    @book = Book.find(params[:id])
    @title = @book.name
    @include_calendar = true
  end

  # POST /books
  # POST /books.xml
  def create
    @parent = Place.find(session[:parent_id])
    @title = 'ახალი წიგნი'
    @include_calendar = true

    @book = Book.new(params[:book])
    @book.place = @parent

    respond_to do |format|
      if @book.save
        format.html { redirect_to(@book, :notice => 'წიგნი შექმნილია.') }
        format.xml  { render :xml => @book, :status => :created, :location => @book }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @book.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /books/1
  # PUT /books/1.xml
  def update
    @book = Book.find(params[:id])
    @title = @book.name
    @include_calendar = true

    respond_to do |format|
      if @book.update_attributes(params[:book])
        format.html { redirect_to(@book, :notice => 'წიგნი განახლებულია.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @book.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.xml
  def destroy
    @book = Book.find(params[:id])
    parent = @book.place
    @book.destroy

    respond_to do |format|
      format.html { redirect_to(:controller => :places, :action => :index, :parent_id => parent.id) }
      format.xml  { head :ok }
    end
  end

  protected

  def redirect_on_failed_check
    redirect_to :controller => :places, :action => :index
  end
  
end
