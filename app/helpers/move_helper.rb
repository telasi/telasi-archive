module MoveHelper

  # გადატანის მისამართი
  def move_link(id, parent1, parent2, which, kind)
    link_to 'გადატანა', :controller => 'move', :action => 'move', :params => move_params(id, parent1, parent2, which, kind)
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
