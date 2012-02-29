class EspnScoreboardParser
  def initialize(sb_filelocation=nil)
    if(sb_filelocation.nil?)
      sb_filelocation = get_location
    end

    @scoreboard = open(sb_filelocation) {|f| Hpricot(f)}
  end
  
  def update_stats
    games.each do |game|
      game_url = "http://scores.espn.go.com/#{game.at('a')['href']}"
      parser = EspnGameParser.new(game_url)
      parser.parse
      away_team = find_team(parser.away_team)
      home_team = find_team(parser.home_team)
      nba_game = NbaGame.find_by_gamedate_and_home_team_id(parser.game_date, home_team.id)
       
      if nba_game.nba_game_team_stats.length > 0
        away_stat = nba_game.nba_game_team_stats.find_by_nba_team_id(away_team.id)
        away_stat.update_attributes(:nba_game => nba_game, :nba_team => away_team, 
                              :FGM => parser.game_stats["away_fg_made"],
                              :FGA => parser.game_stats["away_fg_attempted"],
                              :threePM => parser.game_stats["away_3p_made"],
                              :threePA => parser.game_stats["away_3p_attempted"],
                              :FTM => parser.game_stats["away_ft_made"],
                              :FTA => parser.game_stats["away_ft_attempted"],
                              :ORB => parser.game_stats["away_orb"],
                              :TRB => parser.game_stats["away_trb"],
                              :assists => parser.game_stats["away assists"],
                              :turnovers => parser.game_stats["away turnovers"],
                              :steals => parser.game_stats["away steals"],
                              :blocks => parser.game_stats["away blocks"],
                              :fast_break_points => parser.game_stats["away fast break points"],
                              :fouls => parser.game_stats["away fouls"],
                              :minutes => parser.game_stats["minutes"])
        home_stat = nba_game.nba_game_team_stats.find_by_nba_team_id(home_team.id)
        home_stat.update_attributes(:nba_game => nba_game, :nba_team => home_team, 
                                :FGM => parser.game_stats["home_fg_made"],
                                :FGA => parser.game_stats["home_fg_attempted"],
                                :threePM => parser.game_stats["home_3p_made"],
                                :threePA => parser.game_stats["home_3p_attempted"],
                                :FTM => parser.game_stats["home_ft_made"],
                                :FTA => parser.game_stats["home_ft_attempted"],
                                :ORB => parser.game_stats["home_orb"],
                                :TRB => parser.game_stats["home_trb"],
                                :assists => parser.game_stats["home assists"],
                                :turnovers => parser.game_stats["home turnovers"],
                                :steals => parser.game_stats["home steals"],
                                :blocks => parser.game_stats["home blocks"],
                                :fast_break_points => parser.game_stats["home fast break points"],
                                :fouls => parser.game_stats["home fouls"],
                                :minutes => parser.game_stats["minutes"])

      else
        NbaGameTeamStat.create!(:nba_game => nba_game, :nba_team => away_team, 
                                :FGM => parser.game_stats["away_fg_made"],
                                :FGA => parser.game_stats["away_fg_attempted"],
                                :threePM => parser.game_stats["away_3p_made"],
                                :threePA => parser.game_stats["away_3p_attempted"],
                                :FTM => parser.game_stats["away_ft_made"],
                                :FTA => parser.game_stats["away_ft_attempted"],
                                :ORB => parser.game_stats["away_orb"],
                                :TRB => parser.game_stats["away_trb"],
                                :assists => parser.game_stats["away assists"],
                                :turnovers => parser.game_stats["away turnovers"],
                                :steals => parser.game_stats["away steals"],
                                :blocks => parser.game_stats["away blocks"],
                                :fast_break_points => parser.game_stats["away fast break points"],
                                :fouls => parser.game_stats["away fouls"],
                                :minutes => parser.game_stats["minutes"])
        
        NbaGameTeamStat.create!(:nba_game => nba_game, :nba_team => home_team, 
                                :FGM => parser.game_stats["home_fg_made"],
                                :FGA => parser.game_stats["home_fg_attempted"],
                                :threePM => parser.game_stats["home_3p_made"],
                                :threePA => parser.game_stats["home_3p_attempted"],
                                :FTM => parser.game_stats["home_ft_made"],
                                :FTA => parser.game_stats["home_ft_attempted"],
                                :ORB => parser.game_stats["home_orb"],
                                :TRB => parser.game_stats["home_trb"],
                                :assists => parser.game_stats["home assists"],
                                :turnovers => parser.game_stats["home turnovers"],
                                :steals => parser.game_stats["home steals"],
                                :blocks => parser.game_stats["home blocks"],
                                :fast_break_points => parser.game_stats["home fast break points"],
                                :fouls => parser.game_stats["home fouls"],
                                :minutes => parser.game_stats["minutes"])
        
      end

                              
    end
  end
  
  def games
    @scoreboard.search("//div[@class='expand-gameLinks']")
  end

  private 
    def get_location
      schedule_date = Date.current - 1

      "http://scores.espn.go.com/nba/scoreboard?date=#{schedule_date.strftime('%Y%m%d')}"
    end

    def find_team(city_mascot)
      puts city_mascot
      team = NbaTeam.where("city || ' ' || mascot = ?", city_mascot).first
      if(team.nil?)
        team = NbaTeam.find_by_city(city_mascot.chomp.split(' ')[0])
      end

      team
    end

end
