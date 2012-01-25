class NbaHtmlBoxscore
  def initialize(doc)
    @boxscore = (doc/'#nbaGIboxscore')[0]
  end 

  def away_stats
    away = @boxscore.search('//table')[0]
    get_stat_enum(away)
  end

  def home_stats
    home = @boxscore.search('//table')[1]
    get_stat_enum(home)
  end

  private
    def get_stat_enum(table)
      e = Enumerator.new do |y|
        table.search('//tr').each do |row|
          cells = row.search('//td')
          if(!cells.length.eql?(17) || cells[0].inner_html == "" || cells[0].inner_html == "&nbsp;" || cells[0].inner_html == 'Total')
            next
          end
          
          y << HtmlNbaPlayerStat.new(row)
        end
      end

    end
end
