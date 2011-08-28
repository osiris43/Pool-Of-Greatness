require 'spec_helper'

describe Site do
  def new_site(attributes = {})
    attributes[:name] ||= 'my site name'
    attributes[:description] ||= "my site description"
    attributes[:slug] ||= "mysiteslug"
    Site.new(attributes)
  end

  it "requires a name" do
    new_site({:name => ""}).should_not be_valid
  end

end
