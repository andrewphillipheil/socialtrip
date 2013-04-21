class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable

  has_many :providers, :dependent => :destroy

  has_many :invitations
  has_many :trips, :through => :invitations

  devise :database_authenticatable, :registerable, :token_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :invitable, :invite_for => 0


  devise :omniauthable, :omniauth_providers => [:facebook]

  attr_accessor :auth_hash, :existing, :current_trip, :sender

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :remember_me, :provider, :uid, :first_name, :last_name, :auth_hash, :existing, :current_trip, :sender

  after_create :associate_provider, :if => Proc.new { |u| u.auth_hash }

  after_create :associate_user_to_trip, :if => :invited?
  # attr_accessible :title, :body
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = Provider.where(:user_provider => auth.provider, :uid => auth.uid).first.try(:user)
    unless user
     user = User.create(email:auth.info.email,
                        first_name: auth.extra.raw_info.first_name,
        				        last_name: auth.extra.raw_info.last_name,
                        password:Devise.friendly_token[0,20],
                        auth_hash: auth
                        )
    end
    user
	end

  def has_signed_up_using_fb?
    !!fb_token
  end

  def fb_provider
    @provider ||= providers.where(:user_provider => 'facebook').first
  end

  def fb_token
    fb_provider.try(:token)
  end

  def fb_id
    fb_provider.try(:uid)
  end

  def self.already_invited?(email)
    where(:email => email).first
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def invite
    invite = invitations.build(:trip_id => current_trip.id)    
    send_invitation if invite.save
  end

  def send_invitation
    ::Devise.mailer.send(:invitation_instructions, self).deliver
  end

  def set_trip_and_sender(trip, user)
    self.current_trip = trip
    self.sender = user    
  end


  private

    def associate_provider
      provider = providers.build(:user_provider => auth_hash.provider, :uid => auth_hash.uid, :token => auth_hash.credentials.token)
      provider.save
    end

    def invited?
      !!invited_for_trip || !!invited_by_email?
    end

    def invited_for_trip
      @trip ||= FbInvitee.where(:invitee_uid => auth_hash.uid).first if auth_hash
    end

    def invited_by_email?
      invitation_not_accepted?
    end

    def invitation_not_accepted?
      invitation_token && !first_name
    end 

    def associate_user_to_trip
      invite = if invitation_not_accepted?
        invitations.build(:trip_id => Trip.first.id)
      else
        invitations.build(:trip_id => invited_for_trip.trip_id)
      end
      invite.save
    end    
end
