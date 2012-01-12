class PayThreePlacesStrategy < PlaceStrategy
  def pay_winners
    if @comparer.firstplace.count == 1
      first_prize_percent = 0.7
    elsif @comparer.firstplace.count == 2
      first_prize_percent = 0.9
    else
      first_prize_percent = 1.0
    end

    award_firstplace(first_prize_percent)

    if @comparer.firstplace.count == 1
      if @comparer.secondplace.count == 2
        second_percent = 0.3
      else
        second_percent = 0.2
      end
      award_secondplace(second_percent)
    end 

    if @comparer.firstplace.count + @comparer.secondplace.count < 3
      award_thirdplace(0.1)
    end
    
  end
end
