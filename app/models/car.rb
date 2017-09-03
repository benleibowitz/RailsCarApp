class Car < ActiveRecord::Base
  @@makes = [
      'Acura','Alfa Romeo', 'AMC', 'Aston Martin', 'Audi', 'Bentley', 'BMW',
      'Buick', 'Cadillac', 'Chevrolet', 'Chrysler', 'Daewoo', 'Datsun', 'DeLorean',
      'Dodge', 'Eagle', 'Ferrari', 'FIAT', 'Fisker', 'Ford', 'Freightliner',
      'Genesis', 'Geo', 'GMC', 'Honda', 'HUMMER', 'Hyundai', 'Infiniti', 'Isuzu',
      'Jaguar', 'Jeep', 'Kia', 'Lamborghini', 'Land Rover', 'Lexus', 'Lincoln',
      'Lotus', 'Maserati', 'Maybach', 'Mazda', 'McLaren', 'Mercedes-Benz', 'Mercury',
      'MINI', 'Mitsubishi', 'Nissan', 'Oldsmobile', 'Plymouth', 'Pontiac', 'Porsche',
      'RAM', 'Rolls-Royce', 'Saab', 'Saturn', 'Scion', 'smart', 'SRT', 'Subaru',
      'Suzuki', 'Tesla', 'Toyota', 'Triumph', 'Volkswagen', 'Volvo', 'Yugo', 'Other'
    ]

  # has many
	has_many :modifications, dependent: :destroy
  has_many :assets, dependent: :destroy

  # validates
	validates :year, :make, :model, :price, :presence => true
  validates :make, :inclusion => {
    :in => @@makes,
    :message => 'must be in list of car makes'
  }
  validates :year, numericality: {
    :only_integer => true,
    :greater_than_or_equal_to => 1900,
    :less_than_or_equal_to => 2020
  }
  validates :price, numericality: {
    :only_integer => true,
    :greater_than_or_equal_to => 0,
    :less_than_or_equal_to => 20000000
  }

  default_scope { order('make ASC, year DESC, model ASC') }

	after_save    :expire_car_all_cache
	after_destroy :expire_car_all_cache, :expire_number_cars
  after_create  :expire_number_cars

  def self.makes
    @@makes
  end

  def self.number_cars
    Rails.cache.fetch("Car.number_cars", expires_in: 1.hour) {
      count
    }
  end

	# fetch all cars data (select * from cars ...) from cache
	def self.all_from_cache
	  Rails.cache.fetch("Car.all", expires_in: 1.hour) {
      all
    }
	end

	# after car is saved, delete the (select * ...) data
	# and delete the build cost data from cache
	def expire_car_all_cache
	  Rails.cache.delete("Car.all")
	  Rails.cache.delete("car.build_cost.#{self.id}")
	  Rails.cache.delete("car.number_pics.#{self.id}")
	end

  def expire_number_cars
    Rails.cache.delete("Car.number_cars")
  end

	# method to cache build cost for car instance
	def build_cost
		Rails.cache.fetch("car.build_cost.#{self.id}", expires_in: 1.hour) {
      modifications.sum(:price) + price
    }
	end

  def number_pics
    Rails.cache.fetch("car.number_pics.#{self.id}", expires_in: 1.hour) {
      assets.count
    }
  end

end
