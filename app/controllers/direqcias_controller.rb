# encoding: utf-8
class DireqciasController < ApplicationController
  before_filter :check_edit, :except => [:index, :show]

  # GET /direqcias
  # GET /direqcias.xml
  def index
    @direqcias = Direqcia.all(:order => :code)
    @title = 'დირექციები'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @direqcias }
    end
  end

  # GET /direqcias/1
  # GET /direqcias/1.xml
  def show
    @direqcia = Direqcia.find(params[:id])
    @title = @direqcia.name

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @direqcia }
    end
  end

  # GET /direqcias/new
  # GET /direqcias/new.xml
  def new
    @direqcia = Direqcia.new
    @title = 'ახალი დირექცია'

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @direqcia }
    end
  end

  # GET /direqcias/1/edit
  def edit
    @direqcia = Direqcia.find(params[:id])
    @title = @direqcia.name
  end

  # POST /direqcias
  # POST /direqcias.xml
  def create
    @direqcia = Direqcia.new(params[:direqcia])
    @title = 'ახალი დირექცია'

    respond_to do |format|
      if @direqcia.save
        format.html { redirect_to(@direqcia, :notice => 'დირექცია შექმნილია.') }
        format.xml  { render :xml => @direqcia, :status => :created, :location => @direqcia }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @direqcia.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /direqcias/1
  # PUT /direqcias/1.xml
  def update
    @direqcia = Direqcia.find(params[:id])

    respond_to do |format|
      if @direqcia.update_attributes(params[:direqcia])
        format.html { redirect_to(@direqcia, :notice => 'დირექცია შეცვლილია.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @direqcia.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /direqcias/1
  # DELETE /direqcias/1.xml
  def destroy
    @direqcia = Direqcia.find(params[:id])

    if @direqcia.nomenclatures.empty?
      @direqcia.destroy
    else
      flash[:notice] = 'ეს დირექცია შეიცავს ნომენკლატურებს.'
    end

    respond_to do |format|
      format.html { redirect_to(direqcias_url) }
      format.xml  { head :ok }
    end
  end
end
