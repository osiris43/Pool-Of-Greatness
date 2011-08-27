require 'spec_helper'

describe Account do
  def new_account()
    Account.new
  end

  it "responds to last_transactions" do
    new_account().should respond_to(:last_transactions)
  end
end
