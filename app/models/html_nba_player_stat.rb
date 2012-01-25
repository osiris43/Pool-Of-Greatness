class HtmlNbaPlayerStat

  def initialize(stat_element)
    @stat = stat_element
  end

  def player_name
    player_cell = @stat.search('//td')[0]
    name = player_cell.search('//a').inner_html

    if(name.nil? or name.empty?)
      name = player_cell.inner_html
    end
    
    name
  end

  def minutes
    time_played = @stat.search('//td')[2].inner_html
    time_played.split(':')[0].to_i 
  end

  def seconds 
    time_played = @stat.search('//td')[2].inner_html
    time_played.split(':')[1].to_i 
  end

  def FGM
    field_goals = @stat.search('//td')[3].inner_html
    field_goals.split('-')[0].to_i
  end

  def FGA
    field_goals = @stat.search('//td')[3].inner_html
    field_goals.split('-')[1].to_i
  end

  def threeGM
    threes = @stat.search('//td')[4].inner_html
    threes.split('-')[0].to_i
  end

  def threeGA
    threes = @stat.search('//td')[4].inner_html
    threes.split('-')[1].to_i
  end

  def FTM
    free_throws = @stat.search('//td')[5].inner_html
    free_throws.split('-')[0].to_i
  end

  def FTA
    free_throws = @stat.search('//td')[5].inner_html
    free_throws.split('-')[1].to_i
  end

  def ORB 
    @stat.search('//td')[7].inner_html.to_i
  end

  def DRB 
    @stat.search('//td')[8].inner_html.to_i
  end

  def assists
    @stat.search('//td')[10].inner_html.to_i
  end

  def fouls 
    @stat.search('//td')[11].inner_html.to_i
  end

  def steals 
    @stat.search('//td')[12].inner_html.to_i
  end

  def turnovers 
    @stat.search('//td')[13].inner_html.to_i
  end

  def blocked_shots 
    @stat.search('//td')[14].inner_html.to_i
  end

  def had_blocked 
    @stat.search('//td')[15].inner_html.to_i
  end

  def points 
    @stat.search('//td')[16].inner_html.to_i
  end

  def player_url
    if(@stat.at('a').nil?)
      return ''
    end

    @stat.at('a')['href']
  end
end
