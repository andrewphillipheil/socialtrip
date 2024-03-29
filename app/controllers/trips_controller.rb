class TripsController < ApplicationController
  before_filter :initialize_trip, :only => [:new, :create]
  before_filter :load_trip, :only => [:edit, :destroy, :show, :update, :create_invitation]

  def index
    @trips = current_user.trips
  end

  def new; end

  def show; end

  def create
    if @trip.save
      redirect_to trips_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @trip.update_attributes(params[:trip])
      redirect_to trip_path(@trip)
    else
      render :edit
    end
  end

  def destroy
    if @trip.destroy
      redirect_to trips_path
    end
  end

  def create_invitation
    if @trip.invite!(params[:invitee])
      render :json => {:status => 200}
    else
      render :json => {:status => 304}
    end
  end

  private

    def initialize_trip
      @trip = Trip.new(params[:trip])
      @trip.invitations.build(:user_id => current_user.id)
    end

    def load_trip
      @trip = current_user.trips.where(:id => params[:id]).first
    end
    
end
