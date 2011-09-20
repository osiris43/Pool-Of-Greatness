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
        entry.create_pickem_entry_result(:won => wins, :lost => losses, :tied => ties, :tiebreak_distance => tiebreakDistance.abs, :pickem_week_id => id )
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
    comparer = PickemResultComparer.new(results)
    winner = results[0].pickem_week_entry
    @pool = winner.pickem_week.pickem_pool
    week = winner.pickem_week.week
    season = winner.pickem_week.season

    if results.count < 6
      # yay the simple case
      award_firstplace(comparer, results, @pool, week, season, 1.0)
    elsif results.count < 11
      # if we have a tie for first, all money is split between the ties,
      # else it's the normal 70%
      first_prize_per = 1.0 ? comparer.firstplace.count > 1 : 0.7

      award_firstplace(comparer, results, @pool, week, season, first_prize_per)

      # This only happens if we didn't have a tie so no need to compute
      # the percentage.
      if comparer.firstplace.count == 1
        award_secondplace(comparer, results, @pool, week, season, 0.3)
      end 
    else
      if comparer.firstplace.count == 1
        first_prize_percent = 0.7
      elsif comparer.firstplace.count == 2
        first_prize_percent = 0.9
      else
        first_prize_percent = 1.0
      end

      award_firstplace(comparer, results, @pool, week, season, first_prize_percent)

      if comparer.firstplace.count == 1
        if comparer.secondplace.count == 2
          second_percent = 0.3
        else
          second_percent = 0.2
        end
        award_secondplace(comparer, results, @pool, week, season, second_percent)
      end 

      if comparer.firstplace.count + comparer.firstplace.count < 3
        award_thirdplace(comparer, results, @pool, week, season, 0.1)
      end
    end

    if @pool.award_jackpot?(results[0].won)
      comparer.firstplace.each do |first|
        first.pickem_week_entry.user.account.transaction.create!(:pooltype => "Pickem",
                                                                 :poolname => @pool.name, 
                                                                 :amount => @pool.jackpot.weeklyjackpot / comparer.firstplace.count,
                                                                 :description => "Jackpot for week #{winner.pickem_week.week}, season #{winner.pickem_week.season}")
      end

      @pool.jackpot.weeklyjackpot = 0;
      @pool.jackpot.save
    end

    self.pickem_pool.increment_current_week

  end

  private
    def award_firstplace(comparer, results, pool, week, season, percentage)
      first_place_prize = results.count * pool.prize_amount_per_person * percentage
      comparer.firstplace.each do |first|
        add_transaction(first.pickem_week_entry.user, 
                        "Pickem", 
                        first_place_prize * (1 / comparer.firstplace.count.to_f),
                        "First place prize for week #{week}, #{season}")
      end
    end

    def award_secondplace(comparer, results, pool, week, season, percentage)
      second_place_prize = results.count * pool.prize_amount_per_person * percentage

      comparer.secondplace.each do |second|
        add_transaction(second.pickem_week_entry.user, 
                        "Pickem", 
                        second_place_prize * (1 / comparer.secondplace.count.to_f),
                        "Second place prize for week #{week}, #{season}")

      end
    end

    def award_thirdplace(comparer, results, pool, week, season, percentage)
      third_place_prize = results.count * pool.prize_amount_per_person * percentage

      comparer.thirdplace.each do |third|
        add_transaction(third.pickem_week_entry.user, 
                        "Pickem", 
                        third_place_prize * (1 / comparer.thirdplace.count.to_f),
                        "Third place prize for week #{week}, #{season}")
      end
    end

    def save_pick(gamekey, teamid, current_user, entry)
      logger.debug "Gamekey: #{gamekey}\tTeamId: #{teamid}\tEntryId: #{entry.id}"
      # gamekey looks like gameid_xxx where xxx is the game id
      gameid = gamekey[7..-1].to_i
      pick = entry.pickem_picks.find_by_game_id(gameid) 
      if pick.nil?
        logger.debug "Pick was nil, creating it"
        entry.pickem_picks.create!(:game_id => gamekey[7..-1].to_i, :team_id => teamid.to_i)
      else
        logger.debug "Pick existed, updating it"
        pick.update_attributes(:team_id => teamid)
      end

    end

    def add_transaction(user, pooltype, amount, description)
      user.account.transactions.create!(:pooltype => pooltype,
                                        :poolname => self.pickem_pool.name,
                                        :amount => amount,
                                        :description => description) 
    end

end
