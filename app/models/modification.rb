class Modification < ActiveRecord::Base
  belongs_to :car
  validates :name, :price, :presence => true
  validates :price, numericality: {
    :only_integer => true
  }

  after_save :expire_build_cache
  after_destroy :expire_build_cache

  # method to delete this car's total cost from the cache
  def expire_build_cache
  	Rails.cache.delete(self.car.id)
  end
end
