class NbaTeam < ActiveRecord::Base
  include TeamStatistics

  belongs_to :nba_division
  has_many :nba_players
  has_many :home_games, :foreign_key => "home_team_id", :class_name => "NbaGame"
  has_many :away_games, :foreign_key => "away_team_id", :class_name => "NbaGame"
  
  def display_name
    "#{city.capitalize} #{mascot.capitalize}"
  end

  def points_per_game(game_date=nil)
    if(game_date.nil?)
      game_date = Date.current
    end
    games = away_games.clone
    games.concat(home_games)
    PPG(games.select{|g| g.gamedate < game_date}, self)
    
  end

  def defensive_points_mod(game_date=nil)
    game_date = Date.current unless !game_date.nil?

    points_allowed = home_defensive_mod(game_date)
    points_allowed.concat(away_defensive_mod(game_date))

    points_allowed.inject{|sum,x| sum+x} / points_allowed.length
  end

  private
    def home_defensive_mod(game_date)
      points_allowed = []
      home_games.select{|hg| hg.gamedate < game_date }.each do |g|
        puts "AwayScore: #{g.away_score}\tAway PPG: #{g.away_team.points_per_game(g.gamedate)}"
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
        puts "HomeScore: #{g.home_score}\tHome PPG: #{g.home_team.points_per_game(g.gamedate)}"
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
