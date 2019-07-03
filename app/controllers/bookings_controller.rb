class BookingsController < ApplicationController
  def index
    @bookings = Booking.all
  end

  def show
    find_booking
  end

  def new
    @booking = Booking.new
    listings
  end

  def create
    @booking = Booking.new(booking_params)
    listings
    if @booking.save
      redirect_to bookings_path
    else
      render :new
    end
  end

  def edit
    find_booking
  end

  def update
    find_booking
    listings
    @booking.update(booking_params)
    if @booking.save
      redirect_to booking_path(@booking)
    else
      render :edit
    end
  end

  def destroy
    find_booking
    @booking.destroy
  end

  private

  def booking_params
    params.require(:booking).permit(:listing_id, :start_date, :end_date)
  end

  def find_booking
    @booking = Booking.find(params[:id])
  end

  def listings
    @listings = Listing.all
  end
end
