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

    @bowls = Bowl.where("season = ?", "2010-2011").all
    @ranks = []
    @ranks.push("Select Rank")
    (1..@bowls.count).each {|num| @ranks.push(num)}
    
  end

  def save_picks
    @pool = ConfidencePool.find(params[:id])
    @bowls = Bowl.where("season = ?", "2010-2011").all
    picks = [] 

    existingRanks = [] 
    @bowls.each do |bowl| 
      pick = params["bowlid_"+bowl.id.to_s]
      rank = params["bowlid_rank_"+bowl.id.to_s]
      if(existingRanks.include?(rank))
        # We have a duplicate rank, bail out
        render 'viewbowls'
      end

      existingRanks.push(rank)
      picks.push(ConfidencePick.new(:user => current_user, :bowl => bowl, :team => Team.find(pick.to_i), :rank => rank.to_i))
    end 

    picks.each do |pick|
      pick.save
    end

    flash[:notice] = "Picks saved..."
    redirect_to(confidence_pool_path(@pool))
  end
end
