class Pool < ActiveRecord::Base
  belongs_to :site
  belongs_to :user, :foreign_key => "admin_id"
end
