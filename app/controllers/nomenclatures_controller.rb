class NomenclaturesController < ApplicationController
  before_filter :check_edit, :except => [:index, :show]

  # GET /nomenclatures
  # GET /nomenclatures.xml
  def index
    @nomenclatures = Nomenclature.all(:include => :direqcia, :order => 'direqcias.code, nomenclatures.code')
    @title = 'ნომენკლატურა'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @nomenclatures }
    end
  end

  # GET /nomenclatures/1
  # GET /nomenclatures/1.xml
  def show
    @nomenclature = Nomenclature.find(params[:id])
    @title = @nomenclature.to_s

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @nomenclature }
    end
  end

  # GET /nomenclatures/new
  # GET /nomenclatures/new.xml
  def new
    @nomenclature = Nomenclature.new
    @title = 'ახალი ნომენკლატურა'

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @nomenclature }
    end
  end

  # GET /nomenclatures/1/edit
  def edit
    @nomenclature = Nomenclature.find(params[:id])
    @title = @nomenclature.to_s
  end

  # POST /nomenclatures
  # POST /nomenclatures.xml
  def create
    @nomenclature = Nomenclature.new(params[:nomenclature])
    @title = 'ახალი ნომენკლატურა'

    respond_to do |format|
      if @nomenclature.save
        format.html { redirect_to(@nomenclature, :notice => 'ნომენკლატურა შექმნილია.') }
        format.xml  { render :xml => @nomenclature, :status => :created, :location => @nomenclature }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @nomenclature.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /nomenclatures/1
  # PUT /nomenclatures/1.xml
  def update
    @nomenclature = Nomenclature.find(params[:id])
    @title = @nomenclature.to_s

    respond_to do |format|
      if @nomenclature.update_attributes(params[:nomenclature])
        format.html { redirect_to(@nomenclature, :notice => 'ნომენკლატურა განახლებულია.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @nomenclature.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /nomenclatures/1
  # DELETE /nomenclatures/1.xml
  def destroy
    @nomenclature = Nomenclature.find(params[:id])

    if @nomenclature.books.empty?
      @nomenclature.destroy 
    else
      flash[:notice] = 'ეს ნომენკლატურა შეიცავს წიგნებს.'
    end

    respond_to do |format|
      format.html { redirect_to(nomenclatures_url) }
      format.xml  { head :ok }
    end
  end
end
