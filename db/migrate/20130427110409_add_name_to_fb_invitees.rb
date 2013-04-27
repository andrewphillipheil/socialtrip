class AddNameToFbInvitees < ActiveRecord::Migration
  def change
  	add_column :fb_invitees, :name, :string
  end
end
