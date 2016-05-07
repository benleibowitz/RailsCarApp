class AssetsController < ApplicationController
  before_action :set_asset, only: [:show, :edit, :update, :destroy]

  # GET /assets
  # GET /assets.json
  def index
    @assets = Asset.all
  end

  # GET /assets/1
  # GET /assets/1.json
  def show
  end

  # GET /assets/new
  def new
    @asset = Asset.new
  end

  # GET /assets/1/edit
  def edit
  end

  # POST /assets
  # POST /assets.json
  def create

    @car = Car.find(params[:car_id])

    # This creates a single asset if the picture uploaded
    # is there is no multipart form_for in the html.erb
    #@asset = @car.assets.create(asset_params)

    # This creates assets for EACH image given a multipart
    # form_for assets in the html.erb
    num_images = asset_params[:image].size
    asset_params[:image].each_with_index do |image_asset, idx|
      image_num = idx + 1
      puts "Adding image number #{image_num} / #{num_images}"
      @asset = @car.assets.create({'image' => image_asset})

      # safety check
      break if image_num >= 500
    end

    redirect_to car_path(@car)

  end

  # PATCH/PUT /assets/1
  # PATCH/PUT /assets/1.json
  def update
  end

  # DELETE /assets/1
  # DELETE /assets/1.json
  def destroy
    @car = Car.find(params[:car_id])
    @asset = @car.assets.find(params[:id])
    @asset.destroy

    redirect_to car_path(@car)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_asset
      @asset = Asset.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def asset_params
      params.require(:asset).permit(:car_id, :image => [])
    end
end
