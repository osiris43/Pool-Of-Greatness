module UsersHelper
  def poolpath_for(pool)
    if pool.is_a?(PickemPool)
      return link_to "Pool Home", home_pickem_pool_path(pool)
    elsif pool.is_a?(SurvivorPool)
      return link_to "Pool Home", survivor_pool_path(pool)
    else
      raise TypeError, "pool template unrecognized"
    end 
  end
end
