# წიგნების/თაროების გადატანის კონტროლერი
class MoveController < ApplicationController
  before_filter :check_edit, :except => [:index]

  # საწყისი კონტროლერი
  def index
    @title = 'გადატანა'
    @parent1 = get_parent1
    @parent2 = get_parent2
    @places1 = get_places(@parent1)
    @places2 = get_places(@parent2)
    @books1 = get_books(@parent1)
    @books2 = get_books(@parent2)
  end

  # გადატანის ოპერაცია
  def move
    parent1 = get_parent1
    parent2 = get_parent2
    kind = params[:kind]
    id = params[:object_id]
    which = params[:which]

    newParent = which == '1' ? parent2 : parent1

    if kind == 'book'
      book = Book.find(id)
      if newParent
        book.place = newParent
        if book.save
          flash[:notice] = "წიგნი გადატანილია"
        end
      else
        flash[:notice] = "ზედა დონეზე წიგნს ვერ გადაიტანთ"
      end
    else
      place = Place.find(id)
      if validate_place_inclusion(place, newParent)
        place.parent = newParent
        if place.save
          flash[:notice] = "თარო გადატანილია"
        end
      else
        flash[:notice] = "ჩადგმულ თაროში გადატანა არ შემიძლია"
      end
    end

    redirect_to move_url
  end

private

  def get_parent1
    parent_id1 = params[:parent_id1]
    if parent_id1
      session[:move_parent_id1] = parent_id1.to_i == 0 ? nil : parent_id1.to_i  
    end
    if session[:move_parent_id1]
      Place.find(session[:move_parent_id1])
    else
      nil
    end
  end

  def get_parent2
    parent_id2 = params[:parent_id2]
    if parent_id2
      session[:move_parent_id2] = parent_id2.to_i == 0 ? nil : parent_id2.to_i  
    end
    if session[:move_parent_id2]
      Place.find(session[:move_parent_id2])
    else
      nil
    end
  end

  # თაროების პოვნა
  def get_places(parent)
    if parent
      Place.all(:order => :name, :conditions => ["parent_id = ?", parent.id])
    else
      Place.all(:order => :name, :conditions => ["parent_id is null"])
    end
  end

  def get_books(parent)
    parent ?
      Book.all(:order => :name, :conditions => ["place_id = ?", parent.id]) :
      []
  end

  def validate_place_inclusion(place1, place2)
    return true if place2.nil?
    return false if place1.nil?

    while place2
      return false if place1.eql? place2
      place2 = place2.parent
    end

    true
  end  
end