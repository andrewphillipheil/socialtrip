class Provider < ActiveRecord::Base
  attr_accessible :user_id, :uid, :user_provider

  belongs_to :user
end