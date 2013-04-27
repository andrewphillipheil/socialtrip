class FbInvitee < ActiveRecord::Base
  attr_accessible :trip_id, :invitee_uid, :name
  
  belongs_to :trip
end