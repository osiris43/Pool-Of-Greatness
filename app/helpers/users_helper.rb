module UsersHelper
  def poolpath_for(pool)
    if pool.is_a?(PickemPool)
      return link_to "Home", pickem_home_path(:pool => pool)
    else
      throw Error "pool template unrecognized"
    end 
  end
end
