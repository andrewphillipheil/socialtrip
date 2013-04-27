class InvitationsController < Devise::InvitationsController
  def batch_invite
    trip = Trip.where(:id => params[:user][:trip_id]).first

    if params[:user][:email].present?
      params[:user][:email].split(",").flatten.each do |email|
        if self.resource = (email && resource_class.user_present?(email))
          resource.set_trip_and_sender(trip, current_inviter)
          resource.existing = true
                    
          if resource.already_invited?(trip)
            resource.send_invitation
          else
            resource.invite
          end
        else
          User.current_trip = trip
          self.resource = resource_class.invite!({:email => email}, current_inviter)
          if resource.errors.empty?
            set_flash_message :notice, :send_instructions, :email => email 
          end
        end
      end
      respond_with resource, :location => after_invite_path_for(resource)
    else
      self.resource = resource_class.invite!({:email => params[:user][:email]}, current_inviter)
      render :new
    end  
  end
end