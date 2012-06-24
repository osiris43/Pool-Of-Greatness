class KentuckyDerbyPool < Pool
  attr_accessible :betting_windows

  has_many :betting_windows
  has_and_belongs_to_many :kentucky_derbies

  def current_window 
    d = DateTime.now
    betting_windows.nil? ? nil : betting_windows.where("open <= ? AND close >= ?", d, d).first
  end

  def window_is_open?
    window = current_window
  end
end
