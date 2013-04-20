class CreateInvitees < ActiveRecord::Migration
  def change
    create_table :fb_invitees do |t|
      t.references :trip
      t.string :invitee_uid

      t.timestamp
    end
  end
end
