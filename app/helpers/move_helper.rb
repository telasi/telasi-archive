# encoding: utf-8
module MoveHelper

  # გადატანის მისამართი
  def move_link(id, parent1, parent2, which, kind)
    link_to 'გადატანა', moveplace_url(move_params(id, parent1, parent2, which, kind))
  end

  def place_location_move(p_place1, p_place2, which)
    if which.eql?(1)
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
      text = link_to(place1.name, move_url(places_params(place1, place2, symbol1, symbol2)))
    else
      text = link_to(place1.name, move_url(places_params(place1, place2, symbol1, symbol2))) + ' > ' + text
    end
      place1 = place1.parent
    end
    
    if text.empty?
      text = link_to('საწყისი', move_url(places_params(nil, place2, symbol1, symbol2)))
    else
      text = link_to('საწყისი', move_url(places_params(nil, place2, symbol1, symbol2))) + '  > ' + text
    end
    text
  end

private
  
  def move_params(id, parent1, parent2, which, kind)
    params = {}
    if parent1
      params[:parent_id1] = parent1.id
    end
    if parent2
      params[:parent_id2] = parent2.id
    end
    params[:object_id] = id
    params[:which] = which
    params[:kind] = kind
    params
  end
  
end
