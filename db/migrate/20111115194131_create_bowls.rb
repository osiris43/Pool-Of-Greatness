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
    Bowl.create!(:date => '2010-12-18 15:00:00', :season => "2010-2011", :name => "New Mexico Bowl", :site => "Albuquerque, NM")
    Bowl.create!(:date => '2010-12-18 18:30:00', :season => "2010-2011", :name => "uDrove Humanitarian Bowl", :site => "Boise, ID")
    Bowl.create!(:date => '2010-12-18 22:00:00', :season => "2010-2011", :name => "R+L Carriers New Orleans Bowl", :site => "New Orleans, LA")
    Bowl.create!(:date => '2010-12-21 21:00:00', :season => "2010-2011", :name => "Beef 'O' Brady's St. Petersburg Bowl", :site => "St. Petersburg, FL")
    Bowl.create!(:date => '2010-12-22 21:00:00', :season => "2010-2011", :name => "MAACO Bowl Las Vegas", :site => "Las Vegas, NV")
    Bowl.create!(:date => '2010-12-23 21:00:00', :season => "2010-2011", :name => "San Diego County Credit Union Poinsettia Bowl", :site => "San Diego, CA")
    Bowl.create!(:date => '2010-12-24 21:00:00', :season => "2010-2011", :name => "Sheraton Hawai'i Bowl", :site => "Honolulu, HI")
    Bowl.create!(:date => '2010-12-26 21:00:00', :season => "2010-2011", :name => "Little Caesars Pizza Bowl", :site => "Detroit, MI")
    Bowl.create!(:date => '2010-12-27 18:00:00', :season => "2010-2011", :name => "AdvoCare V100 Independence Bowl", :site => "Shreveport, LA")
    Bowl.create!(:date => '2010-12-28 19:00:00', :season => "2010-2011", :name => "Champs Sports", :site => "Orlando, FL")
    Bowl.create!(:date => '2010-12-28 20:00:00', :season => "2010-2011", :name => "Insight Bowl", :site => "Tempe, AZ")
    Bowl.create!(:date => '2010-12-29 12:00:00', :season => "2010-2011", :name => "Military Bowl presented by Northrop Grumman", :site => "Washington, DC")
    Bowl.create!(:date => '2010-12-29 15:00:00', :season => "2010-2011", :name => "Texas", :site => "Houston, TX")
    Bowl.create!(:date => '2010-12-29 19:00:00', :season => "2010-2011", :name => "Valero Alamo Bowl", :site => "San Antonio, TX")
    Bowl.create!(:date => '2010-12-30 12:00:00', :season => "2010-2011", :name => "Bell Helicopter Armed Forces Bowl", :site => "Dallas, TX")
    Bowl.create!(:date => '2010-12-30 13:00:00', :season => "2010-2011", :name => "New Era Pinstripe Bowl", :site => "Bronx, NY")
    Bowl.create!(:date => '2010-12-30 16:00:00', :season => "2010-2011", :name => "Franklin American Mortgage Music City Bowl", :site => "Nashville, TN")
    Bowl.create!(:date => '2010-12-30 19:00:00', :season => "2010-2011", :name => "Bridgepoint Education Holiday Bowl", :site => "San Diego, CA")
    Bowl.create!(:date => '2010-12-31 13:00:00', :season => "2010-2011", :name => "Meineke Car Care Bowl of Texas", :site => "Houston, TX")
    Bowl.create!(:date => '2010-12-31 14:00:00', :season => "2010-2011", :name => "Hyundai Sun Bowl", :site => "El Paso, TX")
    Bowl.create!(:date => '2010-12-31 15:00:00', :season => "2010-2011", :name => "AutoZone Liberty Bowl", :site => "Memphis, TN")
    Bowl.create!(:date => '2010-12-31 18:00:00', :season => "2010-2011", :name => "Chick-fil-A Bowl", :site => "Atlanta, GA")
    Bowl.create!(:date => '2011-1-1 14:00:00', :season => "2010-2011", :name => "TicketCity Bowl", :site => "Dallas, TX")
    Bowl.create!(:date => '2011-1-1 16:00:00', :season => "2010-2011", :name => "Capital One Bowl", :site => "Orlando, FL")
    Bowl.create!(:date => '2011-1-1 15:00:00', :season => "2010-2011", :name => "Outback Bowl", :site => "Tampa, FL")
    Bowl.create!(:date => '2011-1-1 17:00:00', :season => "2010-2011", :name => "Gator Bowl", :site => "Jacksonville, FL")
    Bowl.create!(:date => '2011-1-1 15:00:00', :season => "2010-2011", :name => "Rose Bowl presented by Vizio", :site => "Pasadena, CA")
    Bowl.create!(:date => '2011-1-1 15:00:00', :season => "2010-2011", :name => "Tostitos Fiesta Bowl", :site => "Glendale, AZ")
    Bowl.create!(:date => '2011-1-4 15:00:00', :season => "2010-2011", :name => "Allstate Sugar Bowl", :site => "New Orleans, LA")
    Bowl.create!(:date => '2011-1-3 15:00:00', :season => "2010-2011", :name => "Discover Orange Bowl", :site => "Miami, FL")
    Bowl.create!(:date => '2011-1-7 15:00:00', :season => "2010-2011", :name => "AT&T Cotton Bowl Classic", :site => "Arlington, TX")
    Bowl.create!(:date => '2011-1-8 15:00:00', :season => "2010-2011", :name => "BBVA Compass Bowl", :site => "Birmingham, AL")
    Bowl.create!(:date => '2011-1-9 12:00:00', :season => "2010-2011", :name => "Kraft Fight Hunger Bowl", :site => "San Francisco, CA")
    Bowl.create!(:date => '2011-1-6 15:00:00', :season => "2010-2011", :name => "GoDaddy.com Bowl", :site => "Mobile, AL")
    Bowl.create!(:date => '2011-1-10 15:00:00', :season => "2010-2011", :name => "Tostitos BCS National Championship Game", :site => "Glendale, AZ")

  end

  def self.down
    drop_table :bowls
  end
end
