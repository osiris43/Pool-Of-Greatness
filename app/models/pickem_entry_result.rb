class PickemEntryResult < ActiveRecord::Base
  # attr_accessor :tiebreak_distance
  attr_accessible :tiebreak_distance, :won, :lost, :tied, :pickem_week_id 
  
  belongs_to :pickem_week_entry
  belongs_to :pickem_week
  
  default_scope order('pickem_entry_results.won DESC','pickem_entry_results.tiebreak_distance')
end
