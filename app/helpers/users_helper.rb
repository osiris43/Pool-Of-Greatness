module UsersHelper
  def poolpath_for(pool)
    case pool.pool_template.name
    when "Pick em"
      return link_to "Home", pickem_home_path(:pool => pool)
    else
      throw Error "pool template unrecognized"
    end 
  end
end
