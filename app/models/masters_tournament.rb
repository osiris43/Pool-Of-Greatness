class MastersTournament < ActiveRecord::Base
  attr_accessible :importfile, :year

#  has_attached_file :importfile

  def process
#    f = importfile.to_file

#    f.readlines[0..-1].each do |line|
#      data = line.split("\t")
#      player_name = data[0]
#      wager_amount = data[1]
#      existing = PgaPlayer.find_by_name(player_name)
#      if(existing.nil?)
#        existing = PgaPlayer.create!(:name => player_name)
#      end

#      MastersQualifier.create!(:pga_player => existing, :masters_tournament => self, :wager_group => wager_amount)

#    end 
  end
end
