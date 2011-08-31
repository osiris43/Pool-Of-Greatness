module UsersHelper
  def poolpath_for(pool)
    if pool.is_a?(PickemPool)
      return link_to pool.name, pickem_home_path(:pool => pool)
    elsif pool.is_a?(SurvivorPool)
      return link_to pool.name, survivor_pool_path(pool)
    else
      raise TypeError, "pool template unrecognized"
    end 
  end
end
