class PagesController < ApplicationController
  def home
    @title = "Host all your pools in one location"
  end

  def pricing
    @title = "Pricing"
  end

  def features
    @title = "Features"
  end

end
