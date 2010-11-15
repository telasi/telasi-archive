class SiteController < ApplicationController
  # საწყისი გვერდი
  def index
    @title = 'საწყისი'
  end

  # სისტემაში ავტორიზაცია
  def login
    @title = 'ავტორიზაცია'
    if request.post?
      user = User.authenticate(params[:name], params[:password])
      if user
        session[:user] = user
        redirect_to :action => 'index'
        return
      else
        flash.now[:notice] = 'არასწორი მომხმარებლი/პაროლი'
      end
    end
    render :layout => 'simple'
  end

  # სისტემიდან გასვლა
  def logout
    @title = 'გასვლა'
    session[:user] = nil
    render :layout => 'simple'
  end

  def change_password
    @title = 'პაროლის შეცვლა'
    if request.post?
      user = session[:user]
      user.password = request[:password]
      user.password_confirmation = request[:password_confirmation]
      if user.save
        flash[:notice] = 'პაროლი შეცვლილია'
        redirect_to :action => 'index'
      else
        flash[:notice] = user.errors.full_messages
      end
    end
  end
end