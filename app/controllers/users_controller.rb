# encoding: utf-8
class UsersController < ApplicationController
  # ამ კონტროლერით სარგებლობა მხოლოდ ადმინისტრატორებს შეუძლიათ
  before_filter :check_admin, :except => [:index, :show]
  
  # GET /users
  # GET /users.xml
  def index
    @users = User.all(:order => :name)
    @title = "მომხმარებლები"

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
    @title = "მომხმარებლის თვისებები"

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
    @title = "ახალი მომხმარებელი"

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    @title = "მომხმარებლის შეცვლა"
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    @title = "ახალი მომხმარებელი"

    respond_to do |format|
      if @user.save
        flash[:notice] = "მომხმარებელი #{@user.name} შექმნილია."
        format.html { redirect_to(:action => 'index') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])
    @title = "მომხმარებლის შეცვლა"

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = "მომხმარებელი #{@user.name} განახლებულია."
        format.html { redirect_to  @user }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
  
end
