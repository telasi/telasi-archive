# encoding: utf-8
class ApplicationController < ActionController::Base
  before_filter :authorize, :except => :login
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  def authorize
    resp = true
    unless session[:user_id]
      flash[:notice] = "გაიარეთ ავტორიზაცია"
      redirect_to login_url
      resp = false
    else
      @user = User.find(session[:user_id])
    end
    resp
  end

  def ar_get_parent
    parent_id = request[:parent_id]
    if parent_id
      session[:parent_id] = parent_id.to_i == 0 ? nil : parent_id
    end
    session[:parent_id] ? Place.find(session[:parent_id]) : nil
  end

  def ar_get_active_nomenclature
    nom_id = request[:nomenclature_id]
    if nom_id.nil?
      nomenclature = session[:active_nomenclature]
    elsif  nom_id.empty?
      session[:active_nomenclature] = nil
      nomenclature = nil
    else
      nomenclature = Nomenclature.find(nom_id)
      session[:active_nomenclature] = nomenclature
    end
    nomenclature
  end

  def get_session_user
    session[:user_id] ? User.find(session[:user_id]) : nil
  end

  def check_admin
    user = get_session_user
    if user
      unless user.admin
        flash[:notice] = 'ადმინისტრირების უფლება არ გაქვთ.'
        redirect_on_failed_check
      end
    end
  end

  def check_edit
    user = get_session_user
    if user
      unless user.editarchive
        flash[:notice] = 'რედაქტირების უფლება არ გაქვთ.'
        redirect_on_failed_check
        return false
      end
    end
    true
  end

  def redirect_on_failed_check
    redirect_to :action => :index
  end

end