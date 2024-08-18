class LocationsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_location, only: [:show, :edit, :update, :destroy]
  
    layout 'admin', if: -> { current_user.admin? }

    def index
      @locations = Location.all
    end
  
    def show
    end
  
    def new
      @location = Location.new
    end
  
    def create
      @location = Location.new(location_params)
      if @location.save
        redirect_to @location, notice: 'Location was successfully created.'
      else
        render :new
      end
    end
  
    def edit
    end
  
    def update
      if @location.update(location_params)
        redirect_to @location, notice: 'Location was successfully updated.'
      else
        render :edit
      end
    end
  
    def destroy
      @location.destroy
      redirect_to locations_url, notice: 'Location was successfully deleted.'
    end

    def available_dates
        location = Location.find(params[:id])
    
        # Assuming that the location has many venues and bookings
        # You might want to modify this logic based on your actual database schema
        booked_dates = Booking.where(venue_id: location.venues.pluck(:id)).pluck(:booking_date)
        available_dates = (Date.today..1.year.from_now).to_a.map(&:to_s) - booked_dates.map(&:to_s)
    
        render json: { available_dates: available_dates }
    end
  
    private
  
    def set_location
      @location = Location.find(params[:id])
    end
  
    def location_params
      params.require(:location).permit(:name, :contact_person)
    end
  end
  