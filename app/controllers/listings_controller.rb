class ListingsController < ApplicationController
  def index
    listings
  end

  def show
    find_listing
  end

  def new
    @listing = Listing.new
  end

  def create
    @listing = Listing.new(listing_params)
    if @listing.save
      redirect_to listings_path
    else
      render :new
    end
  end

  def edit
    find_listing
  end

  def update
    find_listing
    @listing.update(listing_params)
    if @listing.save
      redirect_to listing_path(@listing)
    else
      render :edit
    end
  end

  def destroy
    find_listing
    @listing.destroy
  end

  private

  def listing_params
    params.require(:listing).permit(:id, :num_rooms)
  end

  def find_listing
    @listing = Listing.find(params[:id])
  end

  def listings
    @listings = Listing.all
  end
end
