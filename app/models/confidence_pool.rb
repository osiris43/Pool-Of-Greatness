class ConfidencePool < Pool
  has_many :confidence_picks

  def get_currentgames
    Bowl.where("date between ? AND ?", Date.today, Date.today + 1).all
  end
end
