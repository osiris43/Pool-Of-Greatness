require 'spec_helper'

describe Transaction do
  def new_transaction(attributes = {})
    attributes[:poolname] ||= 'Pool of Greatness'
    attributes[:pooltype] ||= 'Pickem'
    attributes[:amount] ||= -12 
    attributes[:description] ||= 'Description'
    Transaction.new(attributes)
  end

  it "responds to account" do
    new_transaction().should respond_to(:account)
  end
end
