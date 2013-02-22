class OscarNomination < ActiveRecord::Base
  attr_accessible :oscar_award, :oscar_nominee, :year

  belongs_to :oscar_award
  belongs_to :oscar_nominee

  validates :oscar_award_id, presence: true
  validates :oscar_nominee_id, presence: true
  validates :year, presence: true
end
