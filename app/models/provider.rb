class Provider < ActiveRecord::Base
  attr_accessible :user_id, :uid, :user_provider, :token

  belongs_to :user

  def self.user_exists?(uid)
    where(:uid => uid).first.try(:user)
  end

end