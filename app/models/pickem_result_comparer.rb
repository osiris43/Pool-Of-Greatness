class PickemResultComparer
  def initialize(results)
    @results = results
    @firstplace = @secondplace = @thirdplace = []
    compare
  end

  def compare
    first = @results[0]
    @firstplace = @results.find_all { |result| result.won == first.won && result.tiebreak_distance == first.tiebreak_distance}
    @results = @results.drop_while{ |result| @firstplace.include?(result)}

    if @firstplace.count == 1
      second = @results[0]
      @secondplace = @results.find_all {|result| result.won == second.won && result.tiebreak_distance == second.tiebreak_distance}
    end

    if @firstplace.count + @secondplace.count < 3 
      @results = @results.drop_while{ |result| @secondplace.include?(result)}
      third = @results[0]
      @thirdplace = @results.find_all {|result| result.won == third.won && result.tiebreak_distance == third.tiebreak_distance}
    end
  end

  def firstplace
    @firstplace
  end

  def secondplace
    @secondplace
  end
  
  def thirdplace
    @thirdplace
  end
end
