class Api::V1::BookingsController < Api::V1::BaseController
  before_action :find_booking, only: [:show, :update, :destroy]

  def index
    @bookings = Booking.all
  end

  def show
  end

  def create
    @booking = Booking.new(booking_params)
    if @booking.save
      render :show
    else
      render_error
    end
  end

  def update
    if @booking.update(booking_params)
      render :show
    else
      render_error
    end
  end

  def destroy
    @booking.destroy
    head :no_content
  end

  private

  def booking_params
    params.require(:booking).permit(:listing_id, :start_date, :end_date)
  end

  def find_booking
    @booking = Booking.find(params[:id])
  end

  def render_error
    render json: { errors: @booking.errors.full_messages },
      status: :unprocessable_entity
  end
end
