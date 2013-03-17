class NbaGame < ActiveRecord::Base
  attr_accessible :away_team, :home_team, :gamedate, :gametime, :season

  belongs_to :away_team, :foreign_key => 'away_team_id', :class_name => 'NbaTeam'
  belongs_to :home_team, :foreign_key => 'home_team_id', :class_name => 'NbaTeam'
  has_one :score, :class_name => 'NbaGameScore'
  has_many :nba_game_team_stats

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
      return away_score
    elsif(team.id == home_team.id)
      return home_score
    else
      return nil
    end
  end

  def overtime?
    score.nil? ? false : (score.away_overtime + score.home_overtime > 0)
  end

  def played?
    score.nil? ? false : (score.away_total + score.home_total > 0)
  end

  def self.parse_from_html(html, game_date)
    season = DbConfig.get_value_by_key("CurrentNbaSeason")
    away_abbv = (html/'.nbaModTopTeamAw').first.search(".nbaModTopTeamName").inner_html
    away = NbaTeam.find_by_abbreviation(away_abbv.upcase)
    home_abbv = (html/'.nbaModTopTeamHm').first.search(".nbaModTopTeamName").inner_html
    home = NbaTeam.find_by_abbreviation(home_abbv.upcase)
    gt = (html/'.nbaFnlStatTxSm').first.inner_html.upcase
    logger.debug "GameTime #{gt}"
    NbaGame.new(:away_team => away, :home_team => home, :gamedate => game_date, :gametime => Time.parse(gt), :season => season)

  end

  def url
    "http://www.nba.com/games/#{gamedate.strftime('%Y%m%d')}/#{away_team.abbreviation}#{home_team.abbreviation}/gameinfo.html"
  end

  def possessions(team)
    team_stat = nba_game_team_stats.where("nba_team_id = ?", team.id).first
    opp_stat = nba_game_team_stats.where("nba_team_id != ?", team.id).first

    0.5 * ((team_stat.FGA + 0.4 * team_stat.FTA - 1.07 * (team_stat.ORB / (team_stat.ORB + (opp_stat.TRB - opp_stat.ORB))) * (team_stat.FGA - team_stat.FGM) + team_stat.turnovers) + 
            (opp_stat.FGA + 0.4 * opp_stat.FTA - 1.07 * (opp_stat.ORB / (opp_stat.ORB + (team_stat.TRB - team_stat.ORB))) * (opp_stat.FGA - opp_stat.FGM) + opp_stat.turnovers))
  end

  def stat_by_team_and_stattype(team, attr)
    stat = nba_game_team_stats.where("nba_team_id = ?", team.id).first
    stat[attr]
  end
end
