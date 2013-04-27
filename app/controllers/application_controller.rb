class ApplicationController < ActionController::Base

  protect_from_forgery
  before_filter :authenticate_user!, :load_trip

  private 

  def load_trip
  	@trips = current_user.trips if current_user
  end

end
