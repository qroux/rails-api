class ReservationsController < ApplicationController
  def index
    @reservations = Reservation.all
  end

  def show
    find_reservation
  end

  def new
    @reservation = Reservation.new
    listings
  end

  def create
    @reservation = Reservation.new(reservation_params)
    listings #fix simple form listing dropdown content bug when render :new
    if @reservation.save
      redirect_to reservations_path
    else
      render :new
    end
  end

  def edit
    find_reservation
    listings
  end

  def update
    find_reservation
    listings #fix simple form listing dropdown content bug when render :edit
    @reservation.update(reservation_params)
    if @reservation.save
      redirect_to reservation_path(@reservation)
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

  def find_reservation
    @reservation = Reservation.find(params[:id])
  end

  def listings
    @listings = Listing.all
  end
end
