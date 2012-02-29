class NbaPlayer < ActiveRecord::Base
  include NbaPlayerStatistics

  belongs_to :nba_team
  has_many :nba_game_player_stats
  
  validates :lastname, :presence => true
  validates :position, :presence => true

  def display_name
    "#{firstname} #{lastname}"
  end

  def per(season=nil, gamedate=nil)
    efficiency(self.id,season, gamedate) 
  end

  def self.parse_from_html(html, href)
    player_elements = (html/"#playerInfoPos").search("li")
    name_data = player_elements[0].inner_html.split(' ')
    position = player_elements[-1].inner_html
    mascot = (html/'#sideNavLinks').at('a')['href'][1..-2].capitalize
    lastname = get_lastname(name_data)
    firstname = get_firstname(name_data)
    logger.debug "Mascot #{mascot}"
    team = NbaTeam.find_by_mascot(mascot)
    p = NbaPlayer.new(:firstname => firstname, :lastname => lastname, :position => position, :nba_team => team, :player_url => href)
    p
  end

  private
    def self.get_lastname(data)
      if( data.length == 2)
        data[1]
      elsif(data.length > 2)
        data[1..-1].join(' ')
      else 
        data[0]
      end
    end

    def self.get_firstname(data)
      if(data.length == 1)
        ''
      else
        data[0]
      end
    end
end
