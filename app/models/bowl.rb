class Bowl < ActiveRecord::Base
  belongs_to :favorite, :foreign_key => 'favorite_id', :class_name => 'Team'
  belongs_to :underdog, :foreign_key => 'underdog_id', :class_name => 'Team'
  
  default_scope :order => 'bowls.date' 

end
