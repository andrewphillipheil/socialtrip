class Users::InvitationsController < Devise::InvitationsController
  def create
    debugger
    Rails.logger.info "*"*100
    super
  end
end