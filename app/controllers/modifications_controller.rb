class ModificationsController < ApplicationController
	def create
		@car = Car.find(params[:car_id])
		@modification = @car.modifications.create(modification_params)

		redirect_to car_path(@car)
	end

  def index
    @car = Car.find(params[:car_id])
    render json: @car.modifications
  end

  def show
    @modification = Modification.find(params[:id])
    render json: @modification
  end

	def destroy
		@car = Car.find(params[:car_id])
		@modification = @car.modifications.find(params[:id])
		@modification.destroy

		redirect_to car_path(@car)
	end

	private
	def modification_params
		params.require(:modification).permit(:name, :price)
	end
end
