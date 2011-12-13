class User < ActiveRecord::Base
  # new columns need to be added here to be writable through mass assignment
  attr_accessible :username, :email, :password, :password_confirmation, :name
  attr_accessor :password
  before_save :prepare_password
  
  validates_presence_of :username
  validates_uniqueness_of :username, :email, :allow_blank => true
  validates_format_of :username, :with => /^[-\w\._@]+$/i, :allow_blank => true, :message => "should only contain letters, numbers, or .-_@"
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password
  validates_length_of :password, :minimum => 4, :allow_blank => true
  validates_presence_of :name

  has_one :account
  has_many :poolusers
  has_many :pickem_pools, :through => :poolusers  
  has_many :pickem_week_entries
  has_and_belongs_to_many :sites
  has_many :survivor_entries
  has_many :survivor_sessions, :through => :survivor_entries
  has_many :confidence_picks
  has_many :confidence_entries

  # login can be either username or email address
  def self.authenticate(login, pass)
    user = find_by_username(login) || find_by_email(login)
    return user if user && user.password_hash == user.encrypt_password(pass)
  end

  def encrypt_password(pass)
    BCrypt::Engine.hash_secret(pass, password_salt)
  end

  def balance
    unless account.nil?
      account.transactions.inject(0) {|acc, transaction| acc + transaction.amount}
    end
  end

  def pool_admin?(pool)
    id == pool.admin_id
  end

  def favorites_picked
    favorites = 0
    pickem_week_entries.each do |entry|
      entry.pickem_picks.each do |pick|
        if pick.picked_favorite?
          favorites += 1
        end
      end
    end

    favorites
  end

  def underdogs_picked
    underdogs = 0
    pickem_week_entries.each do |entry|
      entry.pickem_picks.each do |pick|
        if pick.picked_underdog?
          underdogs += 1
        end
      end
    end

    underdogs 
  end

  def current_survivor_entries(pool)
    survivor_entries.where("week >= ?", pool.current_session.starting_week).all
  end
 
  def debit_for_survivor?(description)
    account.transactions.where("description LIKE '%#{description}%'").first.nil?
  end 
 
  def site_admin?
    !sites.empty? && sites[0].admin_id == id
  end 

  private

    def prepare_password
      unless password.blank?
        self.password_salt = BCrypt::Engine.generate_salt
        self.password_hash = encrypt_password(password)
      end
    end

end
