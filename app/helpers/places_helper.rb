# encoding: utf-8
module PlacesHelper

  def place_location(place)
    links = []
    while place
      links.push({:url => places_url(:parent_id => place.id), :name => place.name})
      place = place.parent
    end
    render :partial => 'general/places_nav', :locals => { :links => links.reverse }
  end
  
private

  def places_params(place1, place2, symbol1, symbol2)
    if place1 and place2
      {symbol1 => place1.id, symbol2 => place2.id}
    elsif place1
      {symbol1 => place1.id, symbol2 => 0}
    elsif place2
      {symbol2 => place2.id, symbol1 => 0}
    else
      {symbol1 => 0, symbol2 => 0}
    end
  end

end