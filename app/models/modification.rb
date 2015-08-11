class Modification < ActiveRecord::Base
  belongs_to :car
  validates :name, :price, :presence => true
end
