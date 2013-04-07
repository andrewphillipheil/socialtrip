class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable

  has_many :providers

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  devise :omniauthable, :omniauth_providers => [:facebook]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :remember_me, :provider, :uid, :first_name, :last_name
  # attr_accessible :title, :body
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
     user = User.create( provider:auth.provider,
                          uid:auth.uid,
                          email:auth.info.email,
                          first_name: auth.extra.raw_info.first_name,
        				          last_name: auth.extra.raw_info.last_name,
                          password:Devise.friendly_token[0,20]
                          )
    end
    user
	end
end
