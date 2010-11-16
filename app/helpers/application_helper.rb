# საერთო მეთოდები
module ApplicationHelper

  # ხატავს შესაბამის ტაბულაციას
  def ar_draw_tab(cntr, name)
    cntr_name = cntr.controller_name
    text = ar_controller_text name
    if cntr_name.eql? name
      color = ar_controller_color cntr_name
      clazz = 'tab1'
    elsif cntr_name.eql? 'books' and name.eql? 'places' # წიგნები უნდა ამოდიოდეს თაროებში
      color = ar_controller_color cntr_name
      clazz = 'tab1'
    else
      color = 'gray'
      clazz = 'tab2'
    end
    render :partial => 'general/menuitem', :locals => {
      :clazz => clazz, :color => color, :text => text
    }
  end

  # კონტროლერის წარწერა
  def ar_controller_text(name)
    if 'site'.eql? name
      'საწყისი'
    elsif 'users'.eql? name
      'მომხმარებლები'
    elsif 'places'.eql? name or 'books'.eql? name
      'თაროები'
    elsif 'direqcias'.eql? name
      'დირექციები'
    elsif 'nomenclatures'.eql? name
      'ნომენკლატურა'
    elsif 'move'.eql? name
      'გადატანა'
    elsif 'search'.eql? name
      'ძებნა'
    elsif 'tasks'.eql? name
      'დავალებები'
    elsif 'reports'.eql? name
      'რეპორტები'
    else
      '?'
    end
  end

  # კონტროლერის ფერი
  def ar_controller_color(name)
    if 'site'.eql? name
      'red'
    elsif 'users'.eql? name
      'green'
    elsif 'places'.eql? name or 'books'.eql? name
      'orange'
    elsif 'direqcias'.eql? name
      'blue'
    elsif 'nomenclatures'.eql? name
      'olive'
    elsif 'move'.eql? name
      'purple'
    elsif 'search'.eql? name
      'coral'
    elsif 'tasks'.eql? name
      'CadetBlue'
    elsif 'reports'.eql? name
      'Brown'
    else
      'gray'
    end
  end

  # თარიღის ფორმატირება
  def ar_date(dt)
    dt.strftime("%d-%b-%Y")
  end

  # დრო და თარიღის ფორმატირება
  def ar_date_time(dt)
    dt.strftime("%d-%b-%Y %H:%M")
  end

end
