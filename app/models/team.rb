class Team < ActiveRecord::Base
  attr_accessible :teamname, :abbreviation

  has_many :away_games, :class_name => "Game", :foreign_key => "away_team_id"
  has_many :home_games, :class_name => "Game", :foreign_key => "home_team_id"

  def display_name
    teamname
  end

  def games(season=nil)
    if season.nil?
      season = Configuration.find_by_key("CurrentSeason").value
    end

    away_games.find_all { |game| game.season == season} + home_games.find_all { |game| game.season == season}
  end

  def ats_wins
    scored_games = games.find_all{|game| game.scored? && !game.winning_team_ats.nil?}

    scored_games.inject(0) do |acc, game|
      game.winning_team_ats.id == id ? acc += 1 : acc
    end
  end

  def ats_losses
    scored_games = games.find_all{|game| game.scored? && !game.winning_team_ats.nil?}

    scored_games.inject(0) do |acc, game| 
      game.winning_team_ats.id != id ? acc += 1 : acc
    end
  end

  def ats_pushes
    scored_games = games.find_all{|game| game.scored? } 

    logger.debug "Scored games: #{scored_games.count}"
    scored_games.inject(0) do |acc, game| 
      game.homescore + game.line == game.awayscore ? acc += 1: acc
    end
  end

  def this_weeks_opponent
    game = this_weeks_game

    if game.nil?
      return Team.new(:display_name => 'BYE')
    end
    game.home_team.id == id ? game.away_team : game.home_team
  end

  def this_weeks_game
    season = Configuration.find_by_key("CurrentSeason").value
    games.find{ |game| game.season == season && game.gamedate > DateTime.current && game.gamedate < Time.next(:tuesday) } 
  end

  def underdog_losses
    underdog_games.inject(0) do |acc, game|
      game.underdog_score + game.line.abs < game.favorite_score ? acc += 1 : acc 
    end
  end

  def underdog_wins 
    underdog_games.inject(0) do |acc, game|
      game.underdog_score + game.line.abs > game.favorite_score ? acc += 1 : acc 
    end
  end

  def underdog_pushes
    underdog_games.inject(0) do |acc, game|
      game.underdog_score + game.line.abs == game.favorite_score ? acc += 1 : acc
    end
  end

  def favorite_losses
    favorite_games.inject(0) do |acc, game|
      game.favorite_score + game.line < game.underdog_score ? acc += 1 : acc 
    end
  end

  def favorite_wins 
    favorite_games.inject(0) do |acc, game|
      game.favorite_score + game.line > game.underdog_score ? acc += 1 : acc 
    end
  end

  def favorite_pushes
    favorite_games.inject(0) do |acc, game|
      game.favorite_score + game.line == game.underdog_score ? acc += 1 : acc
    end
  end

  def played_games
    games.find_all {|game| game.gamedate < DateTime.current}.sort!{|a,b| a.gamedate <=> b.gamedate } 
  end

  def upcoming_games
    games.find_all {|game| game.gamedate > DateTime.current}.sort!{|a,b| a.gamedate <=> b.gamedate }
  end

  private 
    def underdog_games
      away_underdogs = away_games.find_all { |game| game.line < 0 && (game.scored?) }
      logger.debug "Away Underdog Count: #{away_underdogs}"
      home_underdogs = home_games.find_all { |game| game.line >= 0 && (game.scored?) }
      away_underdogs + home_underdogs
    end

    def favorite_games
      away_favorites = away_games.find_all { |game| game.line >= 0 && (game.scored?) }
      logger.debug "Away Favorites Count: #{away_favorites}"
      home_favorites = home_games.find_all { |game| game.line < 0 && (game.scored?) }
      away_favorites + home_favorites
    end

end
