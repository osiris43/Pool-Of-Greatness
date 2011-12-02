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

    @bowls = Bowl.where("season = ?", season).all
    initialize_viewbowls()

    @picks = current_user.confidence_picks.joins(:bowl).where(:bowls => {:season => season}).all
    @teamids = @picks.map{|pick| pick.team.id}
    @existing_ranks, @existing_bowls = {}, {}
    @picks.map{|pick| 
      @existing_ranks[pick.bowl.id] = pick.rank
      @existing_bowls[pick.rank] = pick.bowl.name
    }
    
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

      existingRanks.push(rank)
      existingPick = ConfidencePick.find_by_user_id_and_bowl_id(current_user.id, bowl.id)
      if(existingPick.nil?)
        picks.push(ConfidencePick.new(:user => current_user, :bowl => bowl, :team => Team.find(pick.to_i), :rank => rank.to_i))
      else
        existingPick.update_attributes(:user => current_user, :bowl => bowl, :team => Team.find(pick.to_i), :rank => rank.to_i)
      end
    end 

    picks.each do |pick|
      pick.save
    end

    flash[:notice] = "Picks saved..."
    redirect_to(confidence_pool_path(@pool))
  end

  def show_leaderboard
    @pool = ConfidencePool.find(params[:id])
    @leaderboard = ConfidenceLeaderboard.new(@pool)
    @leaderboard.build
  end

  private
    def initialize_viewbowls()
      @existing_ranks, @existing_bowls = {}, {}
      @teamids = []
      @ranks = []
      @ranks.push("Select Rank")
      (1..@bowls.count).each {|num| @ranks.push(num)}
    end
end
