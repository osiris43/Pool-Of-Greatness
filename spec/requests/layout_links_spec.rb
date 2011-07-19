require 'spec_helper'

describe "LayoutLinks" do
  it "has a home page at '/'" do
    get '/'
    response.should have_selector("title", :content => "Host all your pools")
  end

  it "has a pricing page at '/pricing'" do
    get '/pricing'
    response.should have_selector("title", :content => "Pricing")
  end

  it "has a features page at '/features'" do
    get '/features'
    response.should have_selector("title", :content => "Features")
  end

  it "has all the correct links on the layout" do
    visit root_path
    response.should have_selector("a", :content => "Pricing")
    response.should have_selector("a", :content => "Features")
  end
end
