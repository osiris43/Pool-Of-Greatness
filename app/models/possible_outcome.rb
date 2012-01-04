class PossibleOutcome
  attr_reader :won, :winnerHash

  def initialize(winnerHash)
    @winnerHash = winnerHash
    @won = {} 
  end

  def score(picks)
    picks.each do |pick|
      # Can't use default hash value because in the instance of 
      # a person who doesn't win any points, that person never gets
      # put into the hash at all.
      if(!@won.has_key?(pick.user.name))
        @won[pick.user.name] = 0
      end
      if(@winnerHash[pick.bowl.id] == pick.team.id)
        @won[pick.user.name] += pick.rank
      end
    end 
  end

  def user_by_place(place)
    # sort_by returns an array of arrays with the key, value pair sorted
    # by the value.
    # so if it's {"brett Bim" => 1, "Tom" => 2} sort_by returns
    # [['Tom', 2], ['brett bim', 1]]
    @won.sort_by{|key,value|-value}[place-1][0]

  end
end
