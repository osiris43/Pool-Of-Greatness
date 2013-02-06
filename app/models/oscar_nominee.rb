class OscarNominee < ActiveRecord::Base
  attr_accessible :nominee

  validates_presence_of :nominee
  validates_uniqueness_of :nominee
end
