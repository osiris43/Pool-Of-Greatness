class GamesParser
  require 'rubygems'
  require 'open-uri'

  def read_document(url)
    open(url) { |f| Hpricot(f)}
  end

  def get_gameids(doc)
    gameids = []
    spans = doc.search("//span[@class='sort']")
    spans.each do |span|
      puts span.inner_html

      gameids << span.inner_html
    end

    gameids
  end

  def get_awayteam(espnid, doc, away_or_home)
    awayItem = doc.search("//p[@id='#{espnid}-#{away_or_home}NameOffset']")
    (awayItem/"a")[0].inner_html
  end

  def get_final_score(espnid, away_or_home, doc)
    # away_or_home is either a or h
    doc.search("//li[@id='#{espnid}-#{away_or_home}Total']").inner_html
  end

  def build_nfl_url(season, seasontype, week)
    "http://scores.espn.go.com/nfl/scoreboard?seasonYear=#{season}&seasonType=#{seasontype}&weekNumber=#{week}"
  end

  def build_ncaa_url(season, seasontype, week)
    "http://scores.espn.go.com/college-football/scoreboard?confId=80&seasonYear=#{season}&seasonType=#{seasontype}&weekNumber=#{week}"
  end

  def parse_nfl_scores(season, seasontype, week)
    doc = read_document(build_nfl_url(season, seasontype, week))
    local_season = season + "-" + (season.to_i + 1).to_s
    parse_scores(doc, week, local_season, 'Nflgame')
  end

  def parse_ncaa_scores(season, seasontype, week)
    doc = read_document(build_ncaa_url(season, seasontype, week))
    local_season = season + "-" + (season.to_i + 1).to_s
    parse_scores(doc, week, local_season, 'Ncaagame')
  end

  def find_game(week, season, awaymascot, type)
    if type == 'Nflgame'
      Nflgame.joins(:away_team).where("week = #{week} AND season = '#{season}' AND teamname LIKE '%" + awaymascot + "%'").readonly(false).first
    else
      Ncaagame.joins(:away_team).where("week = #{week} AND season = '#{season}' AND teamname LIKE '%" + awaymascot + "%'").readonly(false).first
    end
  end

  def parse_scores(doc, week, local_season, type)
    gameids = get_gameids(doc)
    gameids.each do |gameid|
      awaymascot = get_awayteam(gameid, doc, 'a').strip
      homemascot = get_awayteam(gameid, doc, 'h').strip
      awayTotal = get_final_score(gameid, 'a', doc)
      homeTotal = get_final_score(gameid, 'h', doc)
      puts "Away: #{awaymascot}\tHome: #{homemascot}\tAwayTotal: #{awayTotal}\tHomeTotal: #{homeTotal}"

      game = find_game(week, local_season, awaymascot, type)

      if game.nil?
        next
      end

      game.awayscore = awayTotal.to_i
      game.homescore = homeTotal.to_i
      game.save
    end

  end
end
