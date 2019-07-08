class BookingsController < ApplicationController
  before_action :find_booking, only: [:show, :edit, :update, :destroy]
  before_action :listings, only: [:new, :create, :update]

  def index
    @bookings = Booking.all
  end

  def show
  end

  def new
    @booking = Booking.new
  end

  def create
    @booking = Booking.new(booking_params)
    if @booking.save
      redirect_to bookings_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    @booking.update(booking_params)
    if @booking.save
      redirect_to booking_path(@booking)
    else
      render :edit
    end
  end

  def destroy
    if @booking.destroy
      redirect_to bookings_path
    end
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
