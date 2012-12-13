class ConfidencePoolsController < ApplicationController
  def show
    @pool = ConfidencePool.find(params[:id])
    @title = @pool.name
  end

  def administer
    @pool = ConfidencePool.find(params[:id])
    @title = "Administer #{@pool.name}"
  end

  def viewbowls
    @pool = ConfidencePool.find(params[:id])
    season = Configuration.get_value_by_key("CurrentBowlSeason")
    @deadline = DateTime.parse(PoolConfig.find_by_pool_id_and_config_key(@pool.id, "ConfidencePoolDeadline").config_value)
    if(@deadline < DateTime.current)
      flash[:notice] = "The deadline has passed for making or changing picks."
    end

    @bowls = Bowl.order("date").where("season = ?", season).all
    initialize_viewbowls()

    @picks = current_user.confidence_picks.joins(:bowl).where(:bowls => {:season => season}).all
    @teamids = @picks.map{|pick| pick.team.id}
    @existing_ranks, @existing_bowls = {}, {}
    @picks.map{|pick| 
      @existing_ranks[pick.bowl.id] = pick.rank
      @existing_bowls[pick.rank] = pick.bowl.name
    }
   
    @entry = current_user.confidence_entries.where(:season => season).first 
  end

  def save_picks
    @pool = ConfidencePool.find(params[:id])
    @bowls = Bowl.where("season = ?", Configuration.get_value_by_key("CurrentBowlSeason")).all
    picks = [] 

    existingRanks = [] 
    @bowls.each do |bowl| 
      if(params["bowlid_"+bowl.id.to_s].nil?)
        flash[:error] = "You missed selecting a bowl"
        initialize_viewbowls
        @picks = picks
        render 'viewbowls'
        return
      end
      pick = params["bowlid_"+bowl.id.to_s]
      rank = params["bowlid_rank_"+bowl.id.to_s]
      if(existingRanks.include?(rank))
        # We have a duplicate rank, bail out
        flash[:error] = "You have a duplicate rank"
        initialize_viewbowls
        @picks = picks
        render 'viewbowls'
        return
      end

      entry = manage_current_entry(@pool)
      existingRanks.push(rank)
      existingPick = ConfidencePick.find_by_user_id_and_bowl_id(current_user.id, bowl.id)
      if(existingPick.nil?)
        picks.push(ConfidencePick.new(:user => current_user, :bowl => bowl, :team => Team.find(pick.to_i), :rank => rank.to_i, :pool => @pool, :confidence_entry => @entry ))
      else
        existingPick.update_attributes(:user => current_user, :bowl => bowl, :team => Team.find(pick.to_i), :rank => rank.to_i, :pool => @pool, :confidence_entry => @entry)
      end
    end 

    picks.each do |pick|
      pick.save
    end

    verify_accounting(@pool)

    flash[:notice] = "Picks saved..."
    redirect_to(confidence_pool_path(@pool))
  end

  def show_leaderboard
    @pool = ConfidencePool.find(params[:id])
    @leaderboard = ConfidenceLeaderboard.new(@pool)
    @leaderboard.build
  end

  def save_config
    @pool = ConfidencePool.find(params[:id])
    deadline = DateTime.parse("#{params[:bowldeadline][:year]}-#{params[:bowldeadline][:month]}-#{params[:bowldeadline][:day]} #{params[:bowldeadline][:hour]}:#{params[:bowldeadline][:minute]}")

    deadlineConfig = PoolConfig.find_by_pool_id_and_config_key(@pool.id, "ConfidencePoolDeadline")
    if(deadlineConfig.nil?)
      @pool.pool_configs.create!(:config_key => "ConfidencePoolDeadline", :config_value => deadline)
    else
      deadlineConfig.config_value = deadline.to_s
      deadlineConfig.save
    end
    flash[:notice] = "Configuration saved"
    
    redirect_to(confidence_pool_path(@pool))
  end

  def currentgames
    @pool = ConfidencePool.find(params[:id])
    @title = "Current Games"
  end

  def allpicks
    @pool = ConfidencePool.find(params[:id])
    @title = "All Picks"
    @bowls = Bowl.where("season = ?", Configuration.get_value_by_key("CurrentBowlSeason")).all
  end

  def possible_outcomes
    @pool = ConfidencePool.find(params[:id])
    @firsts, @seconds, @thirds, @fourths, @dals = Hash.new(0), Hash.new(0), Hash.new(0), Hash.new(0), Hash.new(0)
    possibles = []
    winnersHash = {}
    possibles_col = []
    @bowls = Bowl.where("season = ?", Configuration.get_value_by_key("CurrentBowlSeason")).all
    bowlsLeft = Bowl.bowls_left
    @possibleCount = 2**bowlsLeft - 1
    # comment out return once enough bowls have been played.
=begin
    @bowls.each do |bowl|
      if(!bowl.winning_team.nil?)
        winnersHash[bowl.id] = bowl.winning_team.id
      else
        possibles_col.push([bowl.favorite.id, bowl.underdog.id, bowl.id])
      end
    end 

    (0..@possibleCount).each do |num|
      binary_poss = ("%b" % num).rjust(bowlsLeft, '0')
      binary_poss.each_char.with_index{|char, idx|
        winnersHash[possibles_col[idx][2]] = possibles_col[idx][char.to_i]
      }
      logger.debug winnersHash
      possibles.push(PossibleOutcome.new(winnersHash.clone))
    end

    possibles.each do |possible|
      possible.score(@pool.confidence_picks)
      @firsts[possible.user_by_place(1)] += 1
      @seconds[possible.user_by_place(2)] += 1
      @thirds[possible.user_by_place(3)] += 1
      @fourths[possible.user_by_place(4)] += 1
      @dals[possible.user_by_place(0)] += 1

    end
=end
  end

  def thelab
    @title = "The Lab"
    @pool = ConfidencePool.find(params[:id])
  end

  private
    def initialize_viewbowls()
      @pool = ConfidencePool.find(params[:id])

      @existing_ranks, @existing_bowls = {}, {}
      @teamids = []
      @ranks = []
      @ranks.push("Select Rank")
      (1..@bowls.count).each {|num| @ranks.push(num)}
      @deadline = DateTime.parse(PoolConfig.find_by_pool_id_and_config_key(@pool.id, "ConfidencePoolDeadline").config_value)

    end

    def verify_accounting(pool)
      transaction = Transaction.find_by_account_id_and_description(current_user.account.id, "Confidence Pool Fee")

      if(transaction.nil?)
        current_user.account.transactions.create!(:pooltype => 'ConfidencePool',
                                          :poolname => pool.name,
                                          :amount => -30,
                                          :description => "Confidence Pool Fee") 
      end 
    end

    def manage_current_entry(pool)
      season = Configuration.get_value_by_key("CurrentBowlSeason")

      @entry = current_user.confidence_entries.where(:season => season).first 
      score = params[:total_score].to_f
      if(@entry.nil?)
        @entry = current_user.confidence_entries.create!(:season => season, :tiebreaker => score, :confidence_pool => pool )
      else
        @entry.tiebreaker = score 
        @entry.save
      end 

      return @entry
    end
end
