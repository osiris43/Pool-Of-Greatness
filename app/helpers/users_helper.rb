module UsersHelper
  def poolpath_for(pool)
    if pool.is_a?(PickemPool)
      return link_to pool.name, home_pickem_pool_path(pool)
    elsif pool.is_a?(SurvivorPool)
      return link_to pool.name, survivor_pool_path(pool)
    elsif pool.is_a?(ConfidencePool)
      return link_to pool.name, confidence_pool_path(pool)
    else
      raise TypeError, "Pool template #{pool.type} unrecognized"
    end 
  end
end
