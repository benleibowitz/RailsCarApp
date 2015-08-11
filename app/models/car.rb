class Car < ActiveRecord::Base
	has_many :modifications, dependent: :destroy
	default_scope { order('make ASC, year DESC') }
	validates :year, :make, :model, :price, :presence => true
end
