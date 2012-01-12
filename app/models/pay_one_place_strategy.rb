class PayOnePlaceStrategy < PlaceStrategy
  def pay_winners
    award_firstplace(1.0)
  end
end
