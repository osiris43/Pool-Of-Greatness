class OscarNominee < ActiveRecord::Base
  attr_accessible :nominee

  validates_presence_of :nominee
  validates_uniqueness_of :nominee

  has_many :oscar_nominations
  has_many :oscar_awards, :through => :oscar_nominations
end
