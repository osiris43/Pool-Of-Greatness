class ConfidencePool < Pool
  has_many :confidence_picks, :foreign_key => :pool_id
  has_many :confidence_entries, :foreign_key => :pool_id

  def get_currentgames
    Bowl.where("date between ? AND ?", Date.today, Date.today + 1).all
  end

  def get_picks_by_rank(bowl, rank)
    confidence_picks.where("bowl_id = ? AND rank = ?", bowl, rank)
  end
end
