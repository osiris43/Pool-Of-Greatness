class PickemWeek < ActiveRecord::Base
  attr_accessible :season, :week, :deadline

  belongs_to :pickem_pool
  has_many :pickem_games
  has_many :pickem_week_entries

  validates :season, :presence => true
  validates_numericality_of :week, :greater_than => 0

  def save_picks(selectedGames, current_user, mnfTotal)
    entry = pickem_week_entries.create!(:user => current_user, :mondaynighttotal => mnfTotal)
    selectedGames.each {|key, value| save_pick(key, value, current_user, entry)} 
  end

  def score
    winningTeams = {}
    tiebreakerTotal = 0
    pickem_games.each do |pg|
      if pg.istiebreaker
        tiebreakerTotal = pg.game.awayscore + pg.game.homescore
      end

      if pg.game.winning_team_ats.id.nil?
        winningTeams[pg.game.id] = 'push'
      else
        winningTeams[pg.game.id] = pg.game.winning_team_ats.id
      end
    end
    
    pickem_week_entries.each do |entry|
      wins = losses = ties = 0

      entry.pickem_picks.each do |pick|
        if winningTeams[pick.game.id] == 'push'
          ties += 1
        elsif winningTeams[pick.game.id] == pick.team.id
          wins += 1
        else
          losses += 1
        end
      end 
      
      tiebreakDistance = tiebreakerTotal - entry.mondaynighttotal
      if entry.pickem_entry_result.nil?
        entry.create_pickem_entry_result(:won => wins, :lost => losses, :tied => ties, :tiebreak_distance => tiebreakDistance.abs )
      else
        entry.pickem_entry_result.update_attributes(:won => wins, :lost => losses, :tied => ties, :tiebreak_distance => tiebreakDistance.abs )
      end
    end
  end

  def self.get_current_week(pool_id)
    @pool = PickemPool.find(pool_id)
    @season = @pool.pickem_rules.where("config_key = ?", "current_season").first
    @week = @pool.pickem_rules.where("config_key = ?", "current_week").first
    logger.debug @season
    logger.debug @week
    @current_week = PickemWeek.where("pickem_pool_id = ? AND season = ? AND week = ?", 
                                        @pool.id,
                                        @season.config_value,
                                        @week.config_value).first

    return @current_week

  end

  def update_accounting
    results = PickemEntryResult.joins(:pickem_week_entry).where('pickem_week_entries.pickem_week_id' => id).all
    if results.count < 6
      winningEntry = results[0].pickem_week_entry
      winningEntry.user.account.transactions.create!(:pooltype => "Pickem",
                                                     :poolname => winningEntry.pickem_week.pickem_pool.name,
                                                     :amount => results.count * 10,
                                                     :description => "Winning prize for week #{winningEntry.pickem_week.week}, season #{winningEntry.pickem_week.season}")
    end

    @week = self.pickem_pool.pickem_rules.where("config_key = ?", "current_week").first
    logger.debug "Found a week"
    newWeek = @week.config_value.to_i + 1
    logger.debug "setting the week to #{newWeek}"
    @week.config_value = newWeek
    @week.save

  end

  private
    def save_pick(gamekey, teamid, current_user, entry)
      # gamekey looks like gameid_xxx where xxx is the game id
      entry.pickem_picks.create!(:game_id => gamekey[7..-1].to_i, :team_id => teamid.to_i)
    end

end
