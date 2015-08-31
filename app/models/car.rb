class Car < ActiveRecord::Base
	has_many :modifications, dependent: :destroy
	default_scope { order('make ASC, year DESC, model ASC') }
	validates :year, :make, :model, :price, :presence => true

	has_attached_file :image
	validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png"]
	validates_attachment_size :image, :less_than => 5.megabytes

	after_save    :expire_car_all_cache
	after_destroy :expire_car_all_cache

	# after car is saved, delete the (select * ...) data
	# and delete the build cost data from cache
	def expire_car_all_cache
	  Rails.cache.delete('Car.all')
	  Rails.cache.delete(self.id)
	end

	# fetch all cars data (select * from cars ...) from cache
	def self.all_from_cache
	  Rails.cache.fetch('Car.all', expires_in: 1.hour) { all }
	end

	# method to cache build cost for car instance
	def build_cost
		Rails.cache.fetch(self.id, expires_in: 1.hour) { modifications.sum(:price) + price }
	end
end
