class NbaGame < ActiveRecord::Base
  attr_accessible :away_team, :home_team, :gamedate, :gametime, :season

  belongs_to :away_team, :foreign_key => 'away_team_id', :class_name => 'NbaTeam'
  belongs_to :home_team, :foreign_key => 'home_team_id', :class_name => 'NbaTeam'
  has_one :score, :class_name => 'NbaGameScore'

  validates :gamedate, :presence => true
  validates :gametime, :presence => true
  validates :season, :presence => true

  def away_score
    score.nil? ? 0 : score.away_total
  end

  def home_score
    score.nil? ? 0 : score.home_total
  end

  def team_score(team)
    if(team.id == away_team.id)
      puts "#{team.display_name}\t#{away_team.display_name}\t#{home_team.display_name}" 
      return away_score
    elsif(team.id == home_team.id)
      puts home_score 
      return home_score
    else
      return nil
    end
  end


  def self.parse_from_html(html, game_date)
    away_abbv = (html/'.nbaModTopTeamAw').first.search(".nbaModTopTeamName").inner_html
    away = NbaTeam.find_by_abbreviation(away_abbv.upcase)
    home_abbv = (html/'.nbaModTopTeamHm').first.search(".nbaModTopTeamName").inner_html
    home = NbaTeam.find_by_abbreviation(home_abbv.upcase)
    gt = (html/'.nbaFnlStatTxSm').first.inner_html.upcase
    logger.debug "GameTime #{gt}"
    NbaGame.new(:away_team => away, :home_team => home, :gamedate => game_date, :gametime => Time.parse(gt), :season => "2011-2012")

  end

  def url
    "http://www.nba.com/games/#{gamedate.strftime('%Y%m%d')}/#{away_team.abbreviation}#{home_team.abbreviation}/gameinfo.html"
  end
end