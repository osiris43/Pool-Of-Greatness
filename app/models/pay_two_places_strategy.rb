class PayTwoPlacesStrategy < PlaceStrategy
  def pay_winners
    # if we have a tie for first, all money is split between the ties,
    # else it's the normal 70%
    first_prize_per = (@comparer.firstplace.count > 1 ? 1.0 : 0.7)

    award_firstplace(first_prize_per)

    # This only happens if we didn't have a tie so no need to compute
    # the percentage.
    if @comparer.firstplace.count == 1
      award_secondplace(0.3)
    end 
  end 
end
