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
    @asset = @car.assets.create(asset_params)

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
      params.require(:asset).permit(:car_id, :image)
    end
end
