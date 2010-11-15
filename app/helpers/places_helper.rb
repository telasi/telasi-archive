module PlacesHelper

  def place_location(place)
    links = []
    while place
      links.push({:url => places_url(:parent_id => place.id), :name => place.name})
      place = place.parent
    end
    render :partial => 'general/places_nav', :locals => { :links => links.reverse }
  end

  def place_location_move(p_place1, p_place2, which)
    if which.eql? 1
      place1 = p_place1
      place2 = p_place2
      symbol1 = :parent_id1
      symbol2 = :parent_id2
    else
      place1 = p_place2
      place2 = p_place1
      symbol1 = :parent_id2
      symbol2 = :parent_id1
    end

    text = ''
    while place1
      if text.empty?
        text = link_to(place1.name, :controller => 'move', :action => 'index', :params => places_params(place1, place2, symbol1, symbol2))
      else
        text = link_to(place1.name, :controller => 'move', :action => 'index', :params => places_params(place1, place2, symbol1, symbol2)) + ' > ' + text
      end
      place1 = place1.parent
    end
    if text.empty?
      text = link_to('საწყისი', :controller => 'move', :action => 'index', :params => places_params(nil, place2, symbol1, symbol2))
    else
      text = link_to('საწყისი', :controller => 'move', :action => 'index', :params => places_params(nil, place2, symbol1, symbol2)) + '  > ' + text
    end
    text
  end
  
  private
  
  def places_params(place1, place2, symbol1, symbol2)
    if place1 and place2
      {symbol1 => place1.id, symbol2 => place2.id}
    elsif place1
      {symbol1 => place1.id}
    elsif place2
      {symbol2 => place2.id}
    else
      {}
    end
  end
  
end
