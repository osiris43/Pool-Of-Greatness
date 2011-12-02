class LeaderboardEntry
  attr_reader :player, :won, :lost, :left, :potential, :percentage
  
  def initialize(user)
    @player = user
    @won = 0
    @lost = 0
    @left = 0
  end

  def score_entry()
    @player.confidence_picks.each do |pick|
      if(pick.bowl.winning_team.nil?)
        @left += pick.rank
      elsif(pick.team == pick.bowl.winning_team)
        @won += pick.rank
      else
        @lost += pick.rank
      end
    end

    @potential = @won + @left
    @percentage = (@won/(@won + @lost)) * 100 unless (@won + @lost) == 0
  end
end
