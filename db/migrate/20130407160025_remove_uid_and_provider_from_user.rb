class RemoveUidAndProviderFromUser < ActiveRecord::Migration
  def up
    # Move existing entries to providers table
    User.where("uid is NOT NULL").each do |u|
      u.providers.create(:uid => u.uid, :user_provider => u.provider )
    end

    remove_column :users, :uid
    remove_column :users, :provider
  end

  def down
    add_column :users, :provider, :string
    add_column :users, :uid, :string    
  end
end
