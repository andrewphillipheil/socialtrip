class Trip < ActiveRecord::Base
  attr_accessible :user_id, :name, :destination, :start_date, :end_date, :description

  has_many :invitations
  has_many :fb_invitees
  has_many :users, :through => :invitations

  validates_presence_of :name, :destination, :description, :start_date, :end_date

  before_validation :parse_date_values

  before_destroy :delete_associated_invitations

  def invite!(invitee)
    if user = Provider.user_exists?(invitee[:uid])
      invite = invitations.build(:user_id => user.id)
      invite.save
    else
      invitee = fb_invitees.build(:invitee_uid => invitee[:uid], :name => invitee[:name])
      invitee.save
    end
  end

  def invitee_already_present?(fb_id)
    fb_invitees.where(:invitee_uid => fb_id).first ? nil : "No" 
  end

  def collect_uids
    fb_invitees.collect(&:invitee_uid)
  end

  def mail_invitees
    users.select{|u| u.providers.where(:user_provider => 'facebook').empty?}.uniq_by(&:email)
  end

  def facebook_invitees_name
    (users.select{|u| u.providers.where(:user_provider => 'facebook').present?}.collect(&:full_name) + FbInvitee.where(:trip_id => id).collect(&:name)).uniq
  end

  private

    def parse_date_values
      parse_start_date if start_date.present?
      parse_end_date if end_date.present?
    end

    def parse_start_date
      self.start_date = start_date.to_date.to_s(:mysql_format)
    end

    def parse_end_date
      self.end_date = end_date.to_date.to_s(:mysql_format)
    end

    def delete_associated_invitations
      invitations.destroy_all
    end
end