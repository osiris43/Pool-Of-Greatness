class PickemPool < Pool
  belongs_to :user, :foreign_key => "admin_id"
  has_many :pickem_rules
  has_many :pickem_weeks

  #validations
  validates_uniqueness_of :name

  # END validations
end
