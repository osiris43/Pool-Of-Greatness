class Pool < ActiveRecord::Base
  attr_accessible :admin_id
  belongs_to :site
  belongs_to :user, :foreign_key => "admin_id"
end
