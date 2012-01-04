class ConfidencePick < ActiveRecord::Base
  belongs_to :bowl
  belongs_to :user
  belongs_to :team
  belongs_to :pool
  belongs_to :confidence_entry
end
