# წიგნების/თაროების გადატანის კონტროლერი
class MoveController < ApplicationController
  before_filter :check_edit, :except => [:index]

  # საწყისი კონტროლერი
  def index
    # სათაურის მიყენება
    @title = 'გადატანა'

    # 'ზედა დონის' პოვნა
    parent_id1 = params[:parent_id1]
    parent_id2 = params[:parent_id2]
    if parent_id1
      @parent1 = Place.find(parent_id1)
    end
    if parent_id2
      @parent2 = Place.find(parent_id2)
    end

    # თაროების პოვნა
    @places1 = get_places(@parent1)
    @places2 = get_places(@parent2)
    @books1 = get_books(@parent1)
    @books2 = get_books(@parent2)
  end

  # გადატანის ოპერაცია
  def move
    # პარამეტრების მიღება
    parent_id1 = params[:parent_id1]
    parent_id2 = params[:parent_id2]
    kind = params[:kind]
    id = params[:object_id]
    which = params[:which]

    # დანიშნულების მიღება
    if which.eql? '1'
      new_parent_id = params[:parent_id2]
    else
      new_parent_id = params[:parent_id1]
    end
    newParent = Place.find(new_parent_id) if new_parent_id

    # ობიექტის მოძებნა და ახალ ადგილას შენახვა
    if 'book'.eql? kind
      book = Book.find(id)
      if newParent
        book.place = newParent
        if book.save
          flash[:notice] = "წიგნი გადატანილია #{newParent.name}-ზე"
        end
      else
        flash[:notice] = "ზედა დონეზე წიგნს ვერ გადაიტანთ"
      end
    else
      place = Place.find(id)
      if validate_place_inclusion place, newParent
        place.parent = newParent
        if place.save
          parentName = newParent ? newParent.name : 'საწყისი'
          flash[:notice] = "თარო გადატანილია #{parentName}-ზე"
        end
      else
        flash[:notice] = "ჩადგმულ თაროში გადატანა არ შემიძლია"
      end
    end

    # გადამისამართება
    redirect_to :action => :index, :params => {:parent_id1 => parent_id1, :parent_id2 => parent_id2}
  end

private

  # თაროების პოვნა
  def get_places(parent)
    if parent
      Place.all(:order => :name, :conditions => ["parent_id = ?", parent.id])
    else
      Place.all(:order => :name, :conditions => ["parent_id is null"])
    end
  end

  # წიგნების პოვნა
  def get_books(parent)
    if parent
      Book.all(:order => :name, :conditions => ["place_id = ?", parent.id])
    else
      []
    end
  end

  # ამოწმებს, place1 თუ შეიცავს place2-ს
  def validate_place_inclusion(place1, place2)
    # ზედა დონეზე ატანა ყოველთვის დაშვებულია
    if place2.nil?
      return true
    end

    # ზედა დონე ყოველთვის შეიცავს ქვედა დონეს!
    # თუმცა ეს სიტუაცია წმინდა თეორიულია, რადგან ფორმიდან არ ხდება ასეთი რამის გამოძახება. 
    if place1.nil?
      return false
    end

    # place2-ის ზედა დონეებში place1-ის ძებნა
    while place2
      # აი ვიპოვეთ!
      if place1.eql? place2
        return false
      end
      place2 = place2.parent
    end

    # ყველა ტესტი გამოვლილია! შეგვიძლია დნება ავრთოთ გადატანაზე
    true
  end
  
end