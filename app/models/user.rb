class User < ActiveRecord::Base
  has_many :games
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      if conditions[:username].nil?
        where(conditions).first
      else
        where(username: conditions[:username]).first
      end
    end
  end
  
  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end
  
  
  def self.from_omniauth(auth)
    where(username: auth.info.name).first_or_create do |user|
        if auth.info.email == nil
          user.email = "no#{auth.uid}@email.com"
        else
          user.email = auth.info.email
        end
        user.password = Devise.friendly_token[0,20]
        user.username = auth.info.name   # assuming the user model has a name
    # If you are using confirmable and the provider(s) you use validate emails, 
    # uncomment the line below to skip the confirmation emails.
    # user.skip_confirmation!
    end
  end
  
  
  def self.find_by_user_by_username(username)
      return User.find_by_username(username)
  end
  
  validates :username,
    :presence => true,
    :uniqueness => {
    :case_sensitive => false
  } 
  
  attr_accessor :login
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :authentication_keys => [:login],
         :omniauth_providers =>[:facebook,:weibo]

         
         
end
