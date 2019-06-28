class ReservationsController < ApplicationController
  def index
    @reservations = Reservation.all
  end

  def show
    find_reservation
  end

  def new
    @reservation = Reservation.new
    @listings = Listing.all
  end

  def create
    @reservation = Reservation.new(reservation_params)
    if @reservation.save
      redirect_to reservations_path
    else
      render :new
    end
  end

  def edit
    find_reservation
  end

  def update
    find_booking
    @booking.update(booking_params)
    if @booking.save
      redirect_to booking_path(@booking)
    else
      render :edit
    end
  end

  def destroy
  end

  private

  def reservation_params
    params.require(:reservation).permit(:listing_id, :start_date, :end_date)
  end

  def find_booking
    @reservation = Reservation.find(params[:id])
  end
end
