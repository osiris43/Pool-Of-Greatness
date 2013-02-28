class NbaTeam < ActiveRecord::Base
  include TeamStatistics
  include LeagueStatistics
  include NbaHelpers

  belongs_to :nba_division
  has_many :nba_players
  has_many :home_games, :foreign_key => "home_team_id", :class_name => "NbaGame"
  has_many :away_games, :foreign_key => "away_team_id", :class_name => "NbaGame"
  has_many :nba_game_team_stats

  def display_name
    "#{city.capitalize} #{mascot.capitalize}"
  end

  def points_per_game(game_date=nil, loc='all')
    game_date = Date.current unless !game_date.nil?
    ppg = 0.0

    if(loc=='all')
      games = away_games.clone
      games.concat(home_games.clone)
      ppg = PPG(games.select{|g| g.gamedate < game_date}, self)
    elsif(loc=='home')
      ppg = PPG(home_games.select{|g| g.gamedate < game_date}, self)
    elsif(loc=='away')
      ppg = PPG(away_games.select{|g| g.gamedate < game_date}, self)
    end

    ppg
  end

  def defensive_points_mod(game_date=nil, loc='all')
    game_date = Date.current unless !game_date.nil?

    if(loc=='all')
      points_allowed = home_defensive_mod(game_date)
      points_allowed.concat(away_defensive_mod(game_date))
    elsif(loc=='home')
      points_allowed = home_defensive_mod(game_date)
    elsif(loc=='away')
      points_allowed = away_defensive_mod(game_date)
    end
    puts points_allowed
    puts points_allowed.length
    points_allowed.inject{|sum,x| sum+x} / points_allowed.length
    
  end

  def lp(season=nil, date=nil)
    league_pace(season, date)
  end

  def tp(season=nil, date=nil)
    tm_pace(self.id, season, date)
  end

  def possessions(season=nil, gamedate=nil)
    season = season_default(season)
    gamedate = gamedate_default(gamedate) 
    tm_fga = team_fga(season, gamedate)
    opp_fga = opponent_fga(season, gamedate)
  end

  private
    def team_fga(season, gamedate)
      fga = 0
      home_games.select{|hg| hg.gamedate < gamedate}.each do |g|
        fga += g.stat_by_team_and_stattype(self, "FGA")
      end
      away_games.select{|ag| ag.gamedate < gamedate}.each do |g|
        fga += g.stat_by_team_and_stattype(self, "FGA")
      end

      fga
    end

    def opponent_fga(season, gamedate)
      fga = 0
      home_games.select{|hg| hg.gamedate < gamedate}.each do |g|
        fga += g.stat_by_team_and_stattype(g.away_team, "FGA")
      end
      away_games.select{|ag| ag.gamedate < gamedate}.each do |g|
        fga += g.stat_by_team_and_stattype(g.home_team, "FGA")
      end

      fga
    end

    def home_defensive_mod(game_date)
      points_allowed = []
      home_games.select{|hg| hg.gamedate < game_date }.each do |g|
        # puts "AwayScore: #{g.away_score}\tAway PPG: #{g.away_team.points_per_game(g.gamedate)}"
        ppg = g.away_team.points_per_game(g.gamedate)
        if(ppg == 0)
          points_allowed.push(1.0)
        else
          points_allowed.push( g.away_score / g.away_team.points_per_game(g.gamedate))
        end
      end

      points_allowed
    end

    def away_defensive_mod(game_date)
      points_allowed = []
      away_games.select{|ag| ag.gamedate < game_date }.each do |g|
        # puts "HomeScore: #{g.home_score}\tHome PPG: #{g.home_team.points_per_game(g.gamedate)}"
        ppg = g.home_team.points_per_game(g.gamedate)
        if(ppg == 0)
          points_allowed.push(1.0)
        else
          points_allowed.push( g.home_score / g.home_team.points_per_game(g.gamedate))
        end
      end

      points_allowed
    end
end
