class Api::V1::ListingsController < Api::V1::BaseController
  before_action :find_listing, only: [:show, :update, :destroy]

  def index
    @listings = Listing.all
  end

  def show
  end

  def create
    @listing = Listing.new(listing_params)
    if @listing.save
      render :show
    else
      render_error
    end
  end

  def update
    if @listing.update(listing_params)
      render :show
    else
      render_error
    end
  end

  def destroy
    @listing.destroy
    head :no_content
  end

  private

  def listing_params
    params.require(:listing).permit(:num_rooms)
  end

  def find_listing
    @listing = Listing.find(params[:id])
  end

  def render_error
    render json: { errors: @listing.errors.full_messages },
      status: :unprocessable_entity
  end
end
