class CreateBowls < ActiveRecord::Migration
  def self.up
    create_table :bowls do |t|
      t.timestamp :date
      t.string :season
      t.string :name
      t.string :site
      t.float :line
      t.references :favorite, :foreign_key => :teams
      t.references :underdog, :foreign_key => :teams

      t.timestamps
    end

    Bowl.reset_column_information
    Bowl.create!(:date => '2011-12-17 14:00:00', :season => "2011", :name => "Gildan New Mexico Bowl", :site => "Albuquerque, NM")
    Bowl.create!(:date => '2011-12-17 17:30:00', :season => "2011", :name => "Famous Idaho Potato Bowl", :site => "Boise, ID")
    Bowl.create!(:date => '2011-12-17 21:00:00', :season => "2011", :name => "R+L Carriers New Orleans Bowl", :site => "New Orleans, LA")
    Bowl.create!(:date => '2011-12-20 20:00:00', :season => "2011", :name => "Beef 'O' Brady's St. Petersburg Bowl", :site => "St. Petersburg, FL")
    Bowl.create!(:date => '2011-12-21 20:00:00', :season => "2011", :name => "San Diego County Credit Union Poinsettia Bowl", :site => "San Diego, CA")
    Bowl.create!(:date => '2011-12-22 20:00:00', :season => "2011", :name => "MAACO Bowl Las Vegas", :site => "Las Vegas, NV")
    Bowl.create!(:date => '2011-12-24 20:00:00', :season => "2011", :name => "Sheraton Hawai'i Bowl", :site => "Honolulu, HI")
    Bowl.create!(:date => '2011-12-26 17:00:00', :season => "2011", :name => "AdvoCare V100 Independence Bowl", :site => "Shreveport, LA")
    Bowl.create!(:date => '2011-12-27 16:30:00', :season => "2011", :name => "Little Caesars Pizza Bowl", :site => "Detroit, MI")
    Bowl.create!(:date => '2011-12-27 20:00:00', :season => "2011", :name => "Belk Bowl", :site => "Charlotte, NC")
    Bowl.create!(:date => '2011-12-28 16:30:00', :season => "2011", :name => "Military Bowl", :site => "Washington, DC")
    Bowl.create!(:date => '2011-12-28 20:00:00', :season => "2011", :name => "Bridgepoint Education Holiday Bowl", :site => "San Diego, CA")
    Bowl.create!(:date => '2011-12-29 17:30:00', :season => "2011", :name => "Champs Sports", :site => "Orlando, FL")
    Bowl.create!(:date => '2011-12-29 21:00:00', :season => "2011", :name => "Valero Alamo Bowl", :site => "San Antonio, TX")
    Bowl.create!(:date => '2011-12-30 12:00:00', :season => "2011", :name => "Bell Helicopter Armed Forces Bowl", :site => "Dallas, TX")
    Bowl.create!(:date => '2011-12-30 15:20:00', :season => "2011", :name => "New Era Pinstripe Bowl", :site => "Bronx, NY")
    Bowl.create!(:date => '2011-12-30 18:40:00', :season => "2011", :name => "Franklin American Mortgage Music City Bowl", :site => "Nashville, TN")
    Bowl.create!(:date => '2011-12-30 22:00:00', :season => "2011", :name => "Insight Bowl", :site => "Tempe, AZ")
    Bowl.create!(:date => '2011-12-31 12:00:00', :season => "2011", :name => "Meineke Car Care Bowl of Texas", :site => "Houston, TX")
    Bowl.create!(:date => '2011-12-31 14:00:00', :season => "2011", :name => "Hyundai Sun Bowl", :site => "El Paso, TX")
    Bowl.create!(:date => '2011-12-31 15:30:00', :season => "2011", :name => "AutoZone Liberty Bowl", :site => "Memphis, TN")
    Bowl.create!(:date => '2011-12-31 15:30:00', :season => "2011", :name => "Kraft Fight Unger Bowl", :site => "San Francisco, CA")
    Bowl.create!(:date => '2011-12-31 19:30:00', :season => "2011", :name => "Chick-fil-A Bowl", :site => "Atlanta, GA")
    Bowl.create!(:date => '2012-1-2 12:00:00', :season => "2011", :name => "TicketCity Bowl", :site => "Dallas, TX")
    Bowl.create!(:date => '2012-1-2 13:00:00', :season => "2011", :name => "Outback Bowl", :site => "Tampa, FL")
    Bowl.create!(:date => '2012-1-2 13:00:00', :season => "2011", :name => "Capital One Bowl", :site => "Orlando, FL")
    Bowl.create!(:date => '2012-1-2 13:00:00', :season => "2011", :name => "Taxslayer.com Gator Bowl", :site => "Jacksonville, FL")
    Bowl.create!(:date => '2012-1-2 17:00:00', :season => "2011", :name => "Rose Bowl presented by Vizio", :site => "Pasadena, CA")
    Bowl.create!(:date => '2012-1-2 18:30:00', :season => "2011", :name => "Tostitos Fiesta Bowl", :site => "Glendale, AZ")
    Bowl.create!(:date => '2012-1-3 20:30:00', :season => "2011", :name => "Allstate Sugar Bowl", :site => "New Orleans, LA")
    Bowl.create!(:date => '2012-1-4 20:00:00', :season => "2011", :name => "Discover Orange Bowl", :site => "Miami, FL")
    Bowl.create!(:date => '2012-1-6 20:00:00', :season => "2011", :name => "AT&T Cotton Bowl Classic", :site => "Arlington, TX")
    Bowl.create!(:date => '2012-1-7 13:00:00', :season => "2011", :name => "BBVA Compass Bowl", :site => "Birmingham, AL")
    Bowl.create!(:date => '2012-1-8 21:00:00', :season => "2011", :name => "GoDaddy.com Bowl", :site => "Mobile, AL")
    Bowl.create!(:date => '2012-1-9 20:30:00', :season => "2011", :name => "Allstate BCS National Championship Game", :site => "New Orleans")

  end

  def self.down
    drop_table :bowls
  end
end
