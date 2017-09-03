class CarsController < ApplicationController
  before_action :set_car, only: [:show, :edit, :update, :destroy]

  def search
    @search_suggestions = Car.where("make LIKE :prm", prm: "#{params[:text].downcase}%")
      .group(:make).distinct.limit(5).pluck(:make)

    render json: @search_suggestions.map(&:downcase)
  end

  # GET /cars
  # GET /cars.json
  def index
    show_count = params.has_key?(:show_all) ? Car.count : params[:page]

    if params.has_key?(:search)
      @cars = Car
        .where("make LIKE :prm OR model LIKE :prm", prm: "%#{params[:search].downcase}%")
        .paginate(:page => show_count)
    else
      @cars = Car.all_from_cache.paginate(:page => 1, :per_page => show_count)
    end
  end

  # GET /cars/1
  # GET /cars/1.json
  def show
  end

  # GET /cars/new
  def new
    @car = Car.new
  end

  # GET /cars/1/edit
  def edit
  end

  # GET /cars/1/clone
  def clone
    @old_car = Car.find(params[:id])
    @car = @old_car.dup

    @old_car.modifications.each do |mod|
      @car.modifications << mod.dup
    end

    @car.save

    #copy over images to new car
    pics_saved = 0
    @old_car.assets.each do |asset|
      new_asset = asset.dup
      new_asset.image = File.open(asset.image.path,'rb')
      @car.assets << new_asset

      pics_saved += 1

      if pics_saved % 3 == 0
        @car.save
      end
    end

    @car.save
    respond_to do |format|
      format.html { redirect_to @car, notice: 'Car successfully duplicated.' }
      format.json { render :show, status: :created, location: @car }
    end
  end

  # POST /cars
  # POST /cars.json
  def create
    @car = Car.new(car_params)

    respond_to do |format|
      if @car.save
        format.html { redirect_to @car, notice: 'Car successfully created.' }
        format.json { render :show, status: :created, location: @car }
      else
        format.html { render :new }
        format.json { render json: @car.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cars/1
  # PATCH/PUT /cars/1.json
  def update
    respond_to do |format|
      if @car.update(car_params)
        format.html { redirect_to @car, notice: 'Car successfully updated.' }
        format.json { render :show, status: :ok, location: @car }
      else
        format.html { render :edit }
        format.json { render json: @car.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cars/1
  # DELETE /cars/1.json
  def destroy
    @car.destroy
    respond_to do |format|
      format.html { redirect_to cars_url, notice: 'Car successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_car
      @car = Car.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def car_params
      params.require(:car).permit(:year, :make, :model, :price, :image)
    end
end
