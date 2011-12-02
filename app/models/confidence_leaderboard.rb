class ConfidenceLeaderboard
  attr_reader :entries

  def initialize(pool)
    @pool = pool
    @entries = []
  end

  def build
    season = Configuration.get_value_by_key("CurrentBowlSeason")
    @players = User.where("users.id IN (SELECT confidence_picks.user_id from confidence_picks INNER JOIN bowls on bowls.id = confidence_picks.bowl_id where bowls.season = ?)", season).all
    @players.each do |player|
      entry = LeaderboardEntry.new(player)
      entry.score_entry()
      @entries.push(entry)
    end 

    entries.sort_by{|entry| -entry.won }
  end
end