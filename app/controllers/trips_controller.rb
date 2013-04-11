class TripsController < ApplicationController
  before_filter :initialize_trip, :only => [:new, :create]
  before_filter :load_trip, :only => [:edit, :destroy, :show]

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
  end

  def destroy
  end

  private

    def initialize_trip
      @trip = current_user.trips.new(params[:trip])
    end

    def load_trip
      @trip = current_user.trips.where(:id => params[:id]).first
    end
end
