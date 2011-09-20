class BodogEvent
  def initialize(html)
    @html = html 
  end 

  def html
    @html
  end

  def away_team
    @away_team
  end

  def home_team
    @home_team
  end

  def line
    @line
  end

  def overunder
    @overunder
  end

  def find_away_team
    doc = Hpricot(@html)
    @away_team = doc.search("//a[@class='competitor']")[0].inner_html
  end

  def find_home_team
    doc = Hpricot(@html)
    @home_team = doc.search("//a[@class='competitor']")[1].inner_html
  end

  def find_line
    # grabbing the away line
    doc = Hpricot(@html)
    line_string = doc.search("//a[@class='lineOdd']")[0].inner_html
    @line = line_string[/.(\d+)/].to_f * -1
  end

  def find_overunder
    doc = Hpricot(@html)
    ou_div = doc.search("//div[@class='total-number']")
    number = (ou_div/"b").inner_html
    if number.length == 2
      @overunder = number.to_f
    else
      @overunder = (number[0..1].to_f) + 0.5
    end
  end

  def parse
    find_away_team
    find_home_team
    find_line
    find_overunder
  end

end
