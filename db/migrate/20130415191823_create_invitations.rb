class CreateInvitations < ActiveRecord::Migration
	def change
    create_table :invitations do |t|
      t.references :user
      t.references :trip      

      t.timestamps
    end
  end
end
