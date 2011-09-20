module UsersHelper
  def poolpath_for(pool)
    if pool.is_a?(PickemPool)
      return link_to pool.name, home_pickem_pool_path(pool)
    elsif pool.is_a?(SurvivorPool)
      return link_to pool.name, survivor_pool_path(pool)
    else
      raise TypeError, "#{pool.is_a?(PickemPool)} pool template #{pool.type} unrecognized"
    end 
  end
end
