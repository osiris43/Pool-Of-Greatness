class Site < ActiveRecord::Base
  belongs_to :user, :foreign_key => "admin_id"
  has_and_belongs_to_many :users
  # Validations
  validates_presence_of :name

end
