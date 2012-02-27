class EspnGameParser
  attr_reader :game_stats, :away_team, :home_team, :game_date

  def initialize(sb_filelocation)
    if(sb_filelocation.nil?)
      raise ArgumentError
    end

    @game = open(sb_filelocation) {|f| Hpricot(f)}
    @game_stats = Hash.new("") 
  end

  def parse
    title = @game.at('title').inner_html
    @away_team = title[0..title.index('vs')-2]
    @home_team = title[title.index('vs')+4..title.index('-')-2]
    @game_date = Date.parse(title.split('-')[2].strip)
    gamedata = @game.search("//table[@class='mod-data']")[0]
    gamedata.search("//tr").each_with_index {|row, idx|
      if(idx == 0)
        next
      elsif(idx == 1)
        # points can be parsed here
      elsif(idx == 2)
        # field goals 
        stats = EspnGameFieldgoals.new(row)
        @game_stats.update(stats.parse_stats)
      elsif(idx == 3)
        threes = EspnGameThrees.new(row)
        @game_stats.update(threes.parse_stats)
      elsif(idx == 4)
        fts = EspnGameFreethrows.new(row)
        @game_stats.update(fts.parse_stats)
      elsif(idx == 5)
        rebounds = EspnGameRebounds.new(row)
        @game_stats.update(rebounds.parse_stats)
      else
        misc_stats = EspnGameTeamStats.new(row)
        @game_stats.update(misc_stats.parse_stats)
      end
    } 
  end
end
