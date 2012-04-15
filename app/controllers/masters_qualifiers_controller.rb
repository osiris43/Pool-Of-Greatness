class MastersQualifiersController < ApplicationController
  def index
    @qualifiers = MastersQualifier.all

    respond_to do |format|
      format.html {}
      format.json { @qualifiers.to_json } 
    end 

  end

end
