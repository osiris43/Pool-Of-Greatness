class MastersEntryPlayer < ActiveRecord::Base
  belongs_to :masters_pool_entry
  belongs_to :masters_qualifiers
end
