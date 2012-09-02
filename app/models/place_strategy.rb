class PlaceStrategy
  def initialize(results, pool)
    @results = results 
    @comparer = PickemResultComparer.new(results)
    @winner = results[0].pickem_week_entry
    @pool = pool
    @week = @winner.pickem_week.week
    @season = @winner.pickem_week.season
  end

  def award_firstplace(percentage)
    first_place_prize = @results.count * @pool.prize_amount_per_person * percentage
    #logger.debug "First Place: #{first_place_prize}"
    #logger.debug "First place count: #{comparer.firstplace.count}"
    @comparer.firstplace.each do |first|
      add_transaction(first.pickem_week_entry.user, 
                      "Pickem", 
                      first_place_prize * (1 / @comparer.firstplace.count.to_f),
                      "First place prize for week #{@week}, #{@season}", @season)
    end
  end

  def award_secondplace(percentage)
    second_place_prize = @results.count * @pool.prize_amount_per_person * percentage

    @comparer.secondplace.each do |second|
      add_transaction(second.pickem_week_entry.user, 
                      "Pickem", 
                      second_place_prize * (1 / @comparer.secondplace.count.to_f),
                      "Second place prize for week #{@week}, #{@season}", @season)

    end
  end

  def award_thirdplace(percentage)
    third_place_prize = @results.count * @pool.prize_amount_per_person * percentage

    @comparer.thirdplace.each do |third|
      add_transaction(third.pickem_week_entry.user, 
                      "Pickem", 
                      third_place_prize * (1 / @comparer.thirdplace.count.to_f),
                      "Third place prize for week #{@week}, #{@season}", @season)
    end
  end

  def add_transaction(user, pooltype, amount, description, season)
    user.account.transactions.create!(:pooltype => pooltype,
                                      :poolname => @pool.name,
                                      :amount => amount,
                                      :description => description,
                                      :season => season) 
  end

  
end
