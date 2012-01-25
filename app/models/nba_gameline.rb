require 'date'
require 'rubygems'
require 'hpricot'
require 'open-uri'

class NbaGameline
  attr_reader :gl_parser

  def initialize(file_location=nil)
    @gl_parser = NbaGamelineParser.new(file_location) 
  end

  def update_stats
    @gl_parser.games.each do |game|
      away_team = NbaTeam.find_by_abbreviation(@gl_parser.get_abbreviation(game, 'away'))
      home_team = NbaTeam.find_by_abbreviation(@gl_parser.get_abbreviation(game, 'home'))
      puts "Home: #{home_team.abbreviation}\tAway: #{away_team.abbreviation}"
      schedule_date = @gl_parser.get_gamedate(game)
      local_game = NbaGame.where('home_team_id = ? AND gamedate = ?', home_team.id, schedule_date).first

      page = NbaGamePage.new("http://www.nba.com/#{@gl_parser.get_game_href(game)}")
      page.boxscore.home_stats.each do |stat|
        if(stat.minutes == 0 and stat.seconds == 0)
          next
        end

        process_stat(stat, home_team, game, local_game)
      end

      page.boxscore.away_stats.each do |stat|
        if(stat.minutes == 0 and stat.seconds == 0)
          next
        end

        process_stat(stat, away_team, game, local_game)
      end

    end
  end

  def process_stat(stat, team, game_element, nbagame)
    player_url = stat.player_url
    if(!player_url.empty?)
      first, last = player_url.split('/')[2].split('_')
      puts "first name: #{first}, lastname: #{last}"
    end

    player = NbaPlayer.find_by_player_url(player_url.chomp('index.html'))
    if(player.nil?)
      player = find_missing_player(player_url, stat.player_name, team)
    end

    if(player.nil?)
      NbaStatImportError.create!(:href => @gl_parser.get_game_href(game_element), :nba_team => team, 
                                 :player_name => stat.player_name, :nba_game => nbagame)
      return 
    end

    player_stat = player.nba_game_player_stats.find_by_nba_game_id(nbagame.id) 
    if(player_stat.nil?)
      player.nba_game_player_stats.create(:nba_game_id => nbagame.id, :minutes => stat.minutes,
                                         :seconds => stat.seconds, 
                                         :FGM => stat.FGM,
                                         :FGA => stat.FGA,
                                         :threePM => stat.threeGM,
                                         :threePA => stat.threeGA,
                                         :FTM => stat.FTM,
                                         :FTA => stat.FTA,
                                         :ORB => stat.ORB,
                                         :DRB => stat.DRB,
                                         :assists => stat.assists,
                                         :fouls => stat.fouls,
                                         :steals => stat.steals,
                                         :turnovers => stat.turnovers,
                                         :blocks => stat.blocked_shots,
                                         :points => stat.points)
    else
      puts "updating a stat"
      player_stat.update_attributes(:minutes => stat.minutes,
                                         :seconds => stat.seconds, 
                                         :FGM => stat.FGM,
                                         :FGA => stat.FGA,
                                         :threePM => stat.threeGM,
                                         :threePA => stat.threeGA,
                                         :FTM => stat.FTM,
                                         :FTA => stat.FTA,
                                         :ORB => stat.ORB,
                                         :DRB => stat.DRB,
                                         :assists => stat.assists,
                                         :fouls => stat.fouls,
                                         :steals => stat.steals,
                                         :turnovers => stat.turnovers,
                                         :blocks => stat.blocked_shots,
                                         :points => stat.points)
    end
  end

  private 
    def find_missing_player(player_url, name, team)
      puts "Missing name: #{name}"
      puts "LastName: #{name.split(' ')[1]}"
      p = team.nba_players.find_by_lastname(name.split(' ')[1])
      if(!p.nil?)
        return p
      end

    end
end
