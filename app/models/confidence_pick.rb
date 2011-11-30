class ConfidencePick < ActiveRecord::Base
  belongs_to :bowl
  belongs_to :user
  belongs_to :team
end
