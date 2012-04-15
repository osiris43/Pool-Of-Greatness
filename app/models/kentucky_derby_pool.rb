class KentuckyDerbyPool < Pool
  attr_accessible :betting_windows

  has_many :betting_windows
  
  def current_window 
    d = DateTime.now
    betting_windows.nil? ? nil : betting_windows.where("open <= ? AND close >= ?", d, d).first
  end
end
