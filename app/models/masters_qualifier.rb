class MastersQualifier < ActiveRecord::Base
  attr_accessible :pga_player, :masters_tournament

  belongs_to :pga_player
  belongs_to :masters_tournament
end
