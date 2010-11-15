class PlacesController < ApplicationController
  before_filter :check_edit, :except => [:index]

  # თაროების გამოჩენა
  def index
    @parent = ar_get_parent
    @nomenclatures = Nomenclature.all(:include => :direqcia, :order => 'direqcias.code, nomenclatures.code')
    @active_nom = ar_get_active_nomenclature

    # სიის ამოღება ზედა დონის მიხედვით
    if @parent
      @places = Place.all(:order => :name, :conditions => ["parent_id = ?", @parent.id])
      @books = Book.all(:order => :order_by, :conditions => ["place_id = ?", @parent.id])
      @title = @parent.name
    else
      @places = Place.all(:order => :name, :conditions => ["parent_id is null"])
      @books = []
      @title = 'თაროები'
    end

    # გვერდის დახატვა
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @places }
    end
  end

  # ნომენკლატურის შეცვლის ბრძანება
  def change_nomenclature
    parent = ar_get_parent
    active_nom = ar_get_active_nomenclature
    book = Book.find(params[:id])
    if book and active_nom
      book.nomenclature = active_nom
      book.save
    end
    redirect_to :action => 'index', :parent_id => parent ? parent.id : nil
    #render :text => 'welcome'
  end
  
  # GET /places/new
  # GET /places/new.xml
  def new
    @place = Place.new
    @title = "ახალი თარო"
    session[:parent_id] = request[:parent_id]
    if session[:parent_id]
      @parent = Place.find(session[:parent_id])
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @place }
    end
  end

  # GET /places/1/edit
  def edit
    @place = Place.find(params[:id])
    @title = "თაროს რედაქტირება"
  end

  # POST /places
  # POST /places.xml
  def create
    @title = "ახალი თარო"
    @place = Place.new(params[:place])
    if session[:parent_id]
      @parent = Place.find(session[:parent_id])
      @place.parent = @parent
    end

    respond_to do |format|
      if @place.save
        flash[:notice] = "თარო #{@place.name} შექმნილია."
        format.html { redirect_to(:action=>'index', :parent_id => (@place.parent ? @place.parent : nil)) }
#        format.xml  { render :xml => @place, :status => :created, :location => @place }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @place.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /places/1
  # PUT /places/1.xml
  def update
    @place = Place.find(params[:id])
    @title = "თაროს რედაქტირება"

    respond_to do |format|
      if @place.update_attributes(params[:place])
        flash[:notice] = "თარო #{@place.name} განახლებულია."
        format.html { redirect_to(:action=>'index', :parent_id => (@place.parent ? @place.parent : nil)) }
#        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
#        format.xml  { render :xml => @place.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /places/1
  # DELETE /places/1.xml
  def destroy
    @place = Place.find(params[:id])
    parent = @place.parent

    # შევამოწმოთ, არის თუ არა ეს თარო ცარიელი
    if @place.children.empty? and @place.books.empty?
      @place.destroy
    else
      flash[:notice] = 'ეს თარო არ არის ცარიელი.'
    end

    # გამოტანა იგივე გვერდის, სადაც ეს თარო იყო განთავსებული
    respond_to do |format|
      if parent
        format.html { redirect_to(:controller => :places, :action => :index, :parent_id => parent.id) }
      else
        format.html { redirect_to(:controller => :places, :action => :index) }
      end
      format.xml  { head :ok }
    end
  end

end
