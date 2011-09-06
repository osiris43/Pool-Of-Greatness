class PickemWeek < ActiveRecord::Base
  attr_accessible :season, :week, :deadline

  belongs_to :pickem_pool
  has_many :pickem_games
  has_many :pickem_week_entries
  has_many :pickem_entry_results

  validates :season, :presence => true
  validates_numericality_of :week, :greater_than => 0

  def save_picks(selectedGames, current_user, mnfTotal)
    entry = pickem_week_entries.find_by_user_id(current_user.id)

    if entry.nil?
      entry = pickem_week_entries.create!(:user => current_user, :mondaynighttotal => mnfTotal)
      current_user.account.transactions.create!(:pooltype => 'Pickem', :poolname => pickem_pool.name, 
                                               :amount => pickem_pool.weeklyfee * -1, 
                                               :description => "Fee for week #{week}, season #{season}")

      pickem_pool.incrementjackpots

    else
      entry.update_attributes(:user => current_user, :mondaynighttotal => mnfTotal) 
    end

    selectedGames.each {|key, value| save_pick(key, value, current_user, entry)} 
  end

  def score
    winningTeams = {}
    tiebreakerTotal = 0
    pickem_games.each do |pg|
      if pg.istiebreaker
        tiebreakerTotal = pg.game.awayscore + pg.game.homescore
      end

      if pg.game.winning_team_ats.nil?
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
    winner = results[0].pickem_week_entry
    @pool = winner.pickem_week.pickem_pool
    week = winner.pickem_week.week
    season = winner.pickem_week.season

    if results.count < 6
      add_transaction(winner.user, "Pickem", results.count * @pool.prize_amount_per_person, week, season)
    elsif results.count < 11
      second = results[1].pickem_week_entry
      add_transaction(winner.user, "Pickem", results.count * @pool.prize_amount_per_person * 0.7, week, season)
      add_transaction(second.user, "Pickem",results.count * @pool.prize_amount_per_person * 0.3, week, season) 
    else
      second = results[1].pickem_week_entry
      third = results[2].pickem_week_entry
      add_transaction(winner.user, "Pickem", results.count * @pool.prize_amount_per_person * 0.7, week, season)
      add_transaction(second.user, "Pickem",results.count * @pool.prize_amount_per_person * 0.2, week, season) 
      add_transaction(third.user, "Pickem", results.count * @pool.prize_amount_per_person * 0.1, week, season)

    end

    if @pool.award_jackpot?(results[0].won)
      winner.user.account.transactions.create!(:pooltype => "Pickem",
                                               :poolname => @pool.name,
                                               :amount => @pool.jackpot.weeklyjackpot,
                                               :description => "Jackpot for week #{winner.pickem_week.week}, season #{winner.pickem_week.season}")

      @pool.jackpot.weeklyjackpot = 0;
      @pool.save
    end

    self.pickem_pool.increment_current_week

  end

  private
    def save_pick(gamekey, teamid, current_user, entry)
      # gamekey looks like gameid_xxx where xxx is the game id
      gameid = gamekey[7..-1].to_i
      pick = entry.pickem_picks.find_by_game_id(gameid) 
      if pick.nil?
        entry.pickem_picks.create!(:game_id => gamekey[7..-1].to_i, :team_id => teamid.to_i)
      else
        pick.update_attributes(:team_id => teamid)
      end

    end

    def add_transaction(user, pooltype, amount, week, season)
      user.account.transactions.create!(:pooltype => pooltype,
                                        :poolname => self.pickem_pool.name,
                                        :amount => amount,
                                        :description => "Winning prize for week #{week}, season #{season}") 
    end

end
