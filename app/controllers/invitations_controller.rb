class InvitationsController < Devise::InvitationsController
  def batch_invite
    trip = Trip.where(:id => params[:user][:trip_id]).first

    params[:user][:email].split(",").each do |email|      
      if self.resource = resource_class.already_invited?(email)
        resource.set_trip_and_sender(trip, current_inviter)
        resource.existing = true
        resource.invite
      else
        self.resource = resource_class.invite!({:email => email}, current_inviter)
        set_flash_message :notice, :send_instructions, :email => email
      end
    end
    respond_with resource, :location => after_invite_path_for(resource)    
  end
end