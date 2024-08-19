class VenuesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_venue, only: [:show, :edit, :update, :destroy]
  
    layout 'admin', if: -> { current_user.admin? }

    def index
      @venues = Venue.all
    end
  
    def show
      @bookings = @venue.bookings.order(:booking_date)
    end
  
    def new
      @venue = Venue.new
    end
  
    def create
      @venue = Venue.new(venue_params)
      if @venue.save
        redirect_to @venue, notice: 'Venue was successfully created.'
      else
        render :new
      end
    end
  
    def edit
    end
  
    def update
      if @venue.update(venue_params)
        redirect_to @venue, notice: 'Venue was successfully updated.'
      else
        render :edit
      end
    end
  
    def destroy
      @venue.destroy
      redirect_to venues_url, notice: 'Venue was successfully deleted.'
    end
  
    private
  
    def set_venue
      @venue = Venue.find(params[:id])
    end
  
    def venue_params
      params.require(:venue).permit(:name, :location_id, :price)
    end
  end
  